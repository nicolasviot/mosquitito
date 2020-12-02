use core
use base
use gui

//Parser of the path string
_define_
ParserMapPath(Process path_){
    path aka path_
    Regex regex ("./cache/.*/(\\S*)/(\\S*)/(\\S*).png")
    path =:> regex.input
    Int z (0)
    Int x (0)
    Int y (0)
    regex.[1] =:> z
    regex.[2] =:> x
    regex.[3] =:> y
}