# Conventions to ease our inter-projects work

## Coding branches

* **master**: this is our default active branch. Nothing can be merged to *master* unless is fully tested and buildable. In master we find the bleeding edge functional code, so merges to it should be pushed frequently.
* **feature-branches**: we always work on a feature-branch. Feature branches are created from *master* `git co -b my-feature master`, and should be kept updated from it (we could create a nested feature-branch, but is better to avoid it). If we are working alone on this branch, then we can constantly do `git fetch` followed by `git rebase origin/master`. If we are working with another team member, then we may use `git fetch` followed by `git merge origin/master` (since we can't modify commits that are already pushed to origin). Features branches are merged back to master.
* **staging**: this is the code that is deployed to our *beta* or *staging* environment. It is updated from *master*, but it can be behind it.
* **production**: this is the code that is deployed to the *production* servers. Its code should have be tested in a *staging* environment previously.
