Hub Cheatsheet
============

A guide for common [hub] CLI commands

We will asume you have an alias for hub `git->hub`

Pull Request
------------

Consider you are creating a feature branch and pushing it to github

    git checkout -b feature
    # (make you changes)
    git commit -m "done with features"
    git push origin feature

To create a pull request against the master branch.

    git pull-request

To create a pull request against other branch.

    git pull-request -b <branch_name>
    # or
    git pull-request -b <username_orgname>:<branch_name>

[hub]: http://hub.github.com/
