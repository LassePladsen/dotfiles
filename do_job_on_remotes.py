#!/bin/python3

from colorama import Fore, Style
import os
import sys
import argparse
import subprocess
from typing import Iterable

JOBS = ["dotfiles", "command"]
DEFAULT_USER = os.environ["USER"]
DEFAULT_REMOTES = [
    "dev",
    "wp3",
    "wp4",
    "bastion",
    "wafmaster",
    "wph",
    "tripletex",
    "afk",
    "avvir",
    "kleins",
    "krydra",
    "upk",
    "bfkstats",
    "fightpark",
    "entercard",
]


class Job:
    def __init__(self, argv: Iterable = []):
        self.argv = argv
        self.args = None

    def main(self):
        """Parse command-line and run jobs"""
        parser = argparse.ArgumentParser(description="Do job on a remote host")

        # Positional argument: job
        parser.add_argument(
            "job",
            default="dotfiles",
            choices=JOBS,
            metavar="job",
            help="What job to do. Default is dotfiles. {%(choices)s}",
        )

        # Optional remote target argument
        parser.add_argument(
            "-r",
            "--remotes",
            help="Comma-separated list of remote(s) to do job on. Hostname, ip, sshconfig, etc. Defaults to harcoded personal remote list",
            default=DEFAULT_REMOTES,
        )

        # Optional user argument
        parser.add_argument(
            "-u",
            "--user",
            help="User to do job on remote as. Defaults to current user",
            default=DEFAULT_USER,
        )

        # Optional verbosity flag
        parser.add_argument(
            "-v", "--verbose", action="count", default=0, help="Increase verbosity"
        )

        # parse arguments and call job function
        self.args = parser.parse_args(self.argv)

        # Parse comma-separated remotes list
        self.args.remotes = self.args.remotes

        match self.args.job:
            case "dotfiles":
                result = self.__scp_dotfiles()
            case "command":
                result = self.__ssh_command()
            case _:
                raise ValueError(
                    f"Unknown job {self.args.job}. The choices are {JOBS}")

        # I think its better to raise error if job failed inside the job function, so this else could be removed, instead catching the error.
        self.__verbose_print(
            "\nJobs done.\n", 0, color=Fore.GREEN) if result else print("Job failed.")

    def __scp_dotfiles(self) -> bool:
        """Scp dotfiles and dependencies to each remote as the given user."""
        remotes = [self.args.remotes,
                   ] if self.args.remotes is str else self.args.remotes.split(",")
        user = self.args.user

        for remote in remotes:
            self.__verbose_print(f"\nStarting on remote {
                                 remote}", color=Fore.YELLOW)

            self.__verbose_print(f"Sending .dotfiles to remote {remote}...")
            if not self.__do_scp(f"{os.path.expanduser('~' + user)}/.bashrc {os.path.expanduser('~' + user)}/.tmux.conf {os.path.expanduser('~' + user)}/.vimrc {user}@{remote}:~{user}/"):
                self.__verbose_print("Could not send dotfiles", color=Fore.RED)

            self.__verbose_print("Checking if tpm is installed...")
            if not self.__do_ssh_command(user, remote, f"test -d ~{user}/.tmux/plugins/tpm"):
                self.__verbose_print(
                    "Tpm not installed - git cloning it...")

                if not self.__do_ssh_command(user, remote, f"git clone https://github.com/tmux-plugins/tpm ~{user}.tmux/plugins/tpm"):
                    self.__verbose_print(
                        "Could not install tpm", color=Fore.RED)

            self.__verbose_print(
                f"Remote {remote} done!", color=Fore.BLUE)
        return True

    def __verbose_print(self, msg: str, verbosity: int = 1, color: Fore = "", end: str = "\n") -> bool:
        """Print message if job ran with verbosity equal to or greater parameter verbosity"""
        if self.args.verbose >= verbosity:
            print(color + msg + Style.RESET_ALL, end=end)
            return True
        return False

    def __ssh_command(self) -> bool:
        raise NotImplementedError()

    def __do_ssh_command(self, user: str, remote: str, cmd: str) -> bool:
        return subprocess.run(
            ["ssh", f"{user}@{remote}", cmd]).returncode == 0

    def __do_scp(self, args: str) -> bool:
        return subprocess.run(["scp"] + args.split()).returncode == 0


if __name__ == "__main__":
    Job(argv=sys.argv[1:]).main()
