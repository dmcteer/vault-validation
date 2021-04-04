#!usr/bin/env python

# Because SaltStack sometimes sucks at handling GitFS and needs a little help
# from a custom Python script.
#
# This script simply runs a git pull on the Salt base directory to look for
# changes to the configuration and will restart the salt-master process if it
# determines the configuration has changed.

import os
import subprocess as subp


def main():

    git_command = ['/usr/bin/git', 'pull']
    repo_path = os.path.dirname('/srv/')

    git_pull = subp.Popen(git_command, cwd=repo_path, stdout=subp.PIPE, stderr=subp.PIPE)
    (git_status, error) = git_pull.communicate()
    if git_pull.poll() == 0:
        if 'Already up-to-date.' in git_status:
            pass
        else:
            os.system('systemctl restart salt-master')


main()
