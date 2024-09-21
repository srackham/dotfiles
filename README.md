# Chezmoi Managed Dotfiles

17-Sep-2024

My cross-distribution Linux dotfiles managed by [chezmoi](https://www.chezmoi.io/).

## TODO
- Transform `tide` alias into a bash function:

      Usage: tide [-w <dir>] [-r]
      -w DIR
        Set working DIR
      -r
        IDE window replaces current window

- See:

  * https://www.perplexity.ai/search/tmux-how-to-name-a-pane-and-pu-IzbfQcOkSvSTN0GPcuJrQg#57
  * `~/bin/tmux-*.sh`
  

Write a bash function that has usage: tide2 [-w <dir>] [-r]

Where:

- `-r` is a boolean option that sets the `replace` local variable which defaults to `false`.
- `-w DIR` is an option that sets the `rootdir` local variable to `DIR`.
- If the `-w` option is omitted `rootdir` defaults to the current working directory.
- The function prints the `replace` and `rootdir` variables then exits.

- Add the long `--replace` option to the replace option.
- Add the `--working-dir` logn option to the `-w` option.
- Add a `-h, --help` option that prints usage.
- Check the path if the `rootdir` variable exists and is a directory, exit with an error message if it does not.

Write a tmux script that performs the following actions:

- Create a new window in the current directory and name it with the base name of the current directory.
- Split the window horizontally.
- Select the left hand pane.
- Kill the previous window.



In the bash `tide` function (listed below) change the `-w <dir>` option to the `<dir>` argument i.e. change the usage from:
 
     tide [-w <dir> | --working-dir <dir>] [-r | --replace] [-h | --help]
        
to:

     tide [-r | --replace] [-h | --help] [<dir>]

    

Modify the bash `frm` function listed below by adding an optional directory argument that specifies the execution directory (defaults to current directory) and add an `-h` option (long `--help` option) that prints the useage and exits. The usage is:

    Usage: frm  [-h | --help] [<dir>]
    
