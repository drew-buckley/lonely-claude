# Lonely Claude

Script intended for running claude inside a VM per repository.
Probably could be generalized to reuse the same VM for multiple repos, but I use claude code on a pretty limited basis so this works for me.
Rust installed on the VM, since thats my drug of choice.

To run, just run `lonely-claude.sh`. `TARGET_PATH` envvar can be used to point it somewhere besides the current working directory.
This will leave the VM running. It can be stopped with `lonely-claude-stop.sh` and destroyed with `lonely-claude-delete.sh`

I personally run things in a script like follows so I'm always closing the VM once I'm done with claude code:
``` sh
lonely-claude.sh ; lonely-claude-stop.sh
```

`lonely-claude-shell-cmd.sh` can be used while the VM is running to execute an arbitrary command within the vm. 
For example, if I wanted to just open a shell:
```
lonely-claude-shell-cmd.sh bash
```
