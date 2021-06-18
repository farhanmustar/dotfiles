Configuration files.

Usage:

```bash
git clone https://github.com/farhanmustar/dotfiles ~/dotfiles
rsync -a ~/dotfiles/ ~
rm -rf ~/dotfiles
```

This configuration require vim 8.0. Older ubuntu system need to update vim using third party source.
```bash
sudo add-apt-repository ppa:jonathonf/vim
sudo apt-get update
sudo apt-get install vim
```

## Vim-Ale linter list
* In vim run `:ALEInfo` to find list of available linter.

### Vim
* [vimls](https://github.com/iamcco/vim-language-server)
  * npm install -g vim-language-server

### Python
* [ale-python-linter](https://github.com/farhanmustar/ale-python-linter)
  * vimrc `Plugin 'farhanmustar/ale-python-linter'`
* flake8
  * pip install flake8
  * more detail checker especially in code formatting.
* bandit
  * pip install bandit
  * security issue checker.

### C++
* clangd
  * apt-get install clangd or clangd-##
    * Create symlink to clangd
  * for ROS development set env variable using shell or in vimrc
    * `let $CPLUS_INCLUDE_PATH='/home/user/ws/devel/include/:/opt/ros/melodic/include/'`
  * or run this command to generate the `compile_command.json`.
    * `catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=1`

### Ros
* [ale-roslint](https://github.com/farhanmustar/ale-roslint)
  * vimrc `Plugin 'farhanmustar/ale-roslint'`
