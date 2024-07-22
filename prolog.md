
## Check value for already running prolog on url
> $ pengine_rpc(+URL, +Query)
"""
Examples:
$ pengine_rpc("http://localhost:3030",robot_status(ridgeback02,X,Y,I,O,T)).
$ pengine_rpc("http://localhost:3030",robot(jackal01,_,_,_)).
"""
