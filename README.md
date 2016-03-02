# Ulrik's vim setup

This setup uses git subtrees to keep track of remote plugin repos and also have the actual plugin source included in this repo. Using this approach, I can both keep track of and update the plugins from their respective remote repos and easily install this on a dev machine without internet access, since I can just copy the whole shebang over to the server instead of pulling all the plugins from github.
Everything in here is a blatant ripoff of an [Atlassian blog post][2]
## Installing
1. Checkout repo
2. Make sure .vimrc is setup correctly (if using the included .vimrc this is not needed)
3. In Vim run `:PluginInstall` (if using Vundle, which you are if you're using this repo)

## Useful commands
### Checking which subtrees are actually included in the repo
There is no easy way to do this currently, since the subtree functionality is apparently just a big shell script atm, but I found this little snippet on [stack overflow][1]

```
git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq | xargs -I {} bash -c 'if [ -d $(git rev-parse --show-toplevel)/{} ] ; then echo {}; fi'
```

This will give a list like this:

```
.vim/bundle/syntastic
.vim/bundle/vim-airline
.vim/bundle/vim-airline-themes
.vim/bundle/vim-fugitive
.vim/bundle/vim-sleuth
```

### Adding a new plugin
#### Quick info
1. `git remote add [remote] [location]`
2. `git subtree add [remote] --prefix [path] [remote] [branch] --squash`
3. In .vimrc: `Plugin 'tpope/vim-sleuth', {'pinned': 1}`
4. In Vim: `PluginInstall`

#### Detailed explanation
The plugins are added as subtrees with [git subtree](https://github.com/git/git/blob/master/contrib/subtree/git-subtree.txt).
In order to keep track of where these plugins live, I've included them as remotes. So the first thing to do is add a new remote to the repo:  

General case:  
`git remote add [remote name] [remote location]`

Example:  
`git remote add vim-sleuth https://github.com/tpope/vim-sleuth.git`

That takes care of where the plugin source is located so we don't have to remember it next time we want to update it. Next step is actually adding the plugin as a subtree:

General case:  
`git subtree add --prefix [path to the plugin top-dir] [remote name] [branch] --squash`

Example:  
`git subtree add --prefix .vim/bundle/vim-sleuth vim-sleuth master --squash`

* The `--prefix` is where you want the subtree to be rooted, in our case the top level dir of the vim plugin
* The remote name is the same as the remote we added in step 1.
* The branch is usually `master` but you could use any branch on that remote.
* The `--squash` is just there so we don't import the entire history of the plugin, we create a shallow copy with just 1 commit and merge that into our repo

The last step is telling Vim to use the new plugin. When using Vundle (which we are) this is done in .vimrc by adding the following line with the rest of the plugin directives:
General case:  
`Plugin '[plugin address]', {'pinned': 1}`
Example:  
`Plugin 'tpope/vim-sleuth', {'pinned': 1}`

The `pinned` setting makes sure Vundle doesn't try to pull the plugin from github, since we are managing them directly with our subtrees.

And lastly, in Vim we run the Vundle command `PluginInstall` to actually load the plugin into vim. This only needs to be run when installing/updating new plugins, not every time you start Vim.

### Updating an existing plugin
#### Quick info
1. `git fetch [remote] [branch]`
2. `git subtree pull --prefix [path] [remote] [branch] --squash`

#### Detailed explanation
In order to update a plugin you need to fetch the remote changes as usual with `git fetch [remote] [branch]`.

Example:
`git fetch vim-sleuth master`

Omitting the branch would also work, but we don't want to bloat our repo more than needed, so we just pick a specific branch.

Then we need to update the actual subtree in our repo. This is done with `git subtree pull`.

General case:
`git subtree pull --prefix [path] [remote] [branch] --squash`

Example:
`git subtree pull --prefix .vim/bundle/vim-sleuth vim-sleuth master --squash`

The trick here is to keep track of which where a specific subtree is located in our repo. For an explanation of how to find this out, see [checking which subtrees are actually included in this repo](Checking which subtrees are actually included in the repo)
 
### References
[1]: http://stackoverflow.com/a/18339297/306458
[2]: http://blogs.atlassian.com/2013/05/alternatives-to-git-submodule-git-subtree/
