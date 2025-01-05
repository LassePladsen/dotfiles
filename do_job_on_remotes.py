#!/bin/python3

import os
import sys
import argparse
import subprocess
from typing import Iterable

JOBS = ["scp_dotfiles", "ssh_command"]
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
            help="Comma-separated list of remote(s) to do job on. Hostname, ip, sshconfig, etc. Defaults to harcoded personal remote list.",
            default=DEFAULT_REMOTES,
        )

        # Optional user argument
        parser.add_argument(
            "-u",
            "--user",
            help="User to do job on remote as. Defaults to current user.",
            default=DEFAULT_USER,
        )

        # Optinal verbosity flag
        parser.add_argument("-v", "--verbose", action="count", default=0)

        # parse arguments and call job function
        self.args = parser.parse_args(self.argv)

        match self.args.job:
            case "scp_dotfiles":
                result = self.scp_dotfiles()
            case "ssh_command":
                result = self.ssh_command()
            case _:
                raise ValueError(f"Unknown job {self.args.job}. The choices are {JOBS}")

        # I think its better to raise error if job failed inside the job function, so this else could be removed, instead catching the error.
        print("Jobs done.") if result else print("Job failed.")

    def scp_dotfiles(self, user=DEFAULT_USER, remotes=DEFAULT_REMOTES):
        for remote in remotes:
            print("Checking if tpm is installed") if self.args.verbose > 0 else None
            # subprocess.run(["ssh", "{user}@{remote}", "test", "-d", "/home/{user}/.tmux"])
            print(f"{user}@{remote}, test, -d, /home/{user}/.tmux])")
        return True


if __name__ == "__main__":
    Job(argv=sys.argv[1:]).main()
