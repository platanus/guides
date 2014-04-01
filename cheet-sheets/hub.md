Hub Cheetsheat
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

You can also assign a pull-request to an existing issue

    git pull-request -i <issue_github_url>
    # example
    git pull-request -i https://github.com/platanus/guides/issues/1


[hub]: http://hub.github.com/
