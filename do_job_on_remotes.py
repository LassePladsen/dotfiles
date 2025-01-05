#!/usr/bin/python3
# import cli.app
#
# @cli.app.CommandLineApp
# def main(app):
#    print("start")
#    print(params)

# main.add_param("-w", help="hello world")
import typer
import subprocess
from enum import Enum
remotes = ["dev", "wp3", "wp4", "bastion", "wafmaster", "wph", "tripletex",
           "afk", "avvir", "kleins", "krydra", "upk", "bfkstats", "fightpark", "entercard"]


app = typer.Typer()


class Job(str, Enum):
    dotfiles = "dotfiles"
    command = "command"


@app.command()
def dotfiles(remotes: list[str] = remotes, user: str = "lasse"):
    remotes = ["test"]
    for remote in remotes:
        print("Checking if vim-plug is installed")
        subprocess.run(["ssh", "$user@$remote", "test", "-d", "/home/$user/.tmux"])
        # print(f"Sending dotfiles to {remote}:~{user} ...")
        # subprocess.run(["ls", "-l"])


if __name__ == "__main__":
    app()
