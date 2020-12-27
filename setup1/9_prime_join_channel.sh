#!/bin/sh

chmod -R 777 .


join2(){
    echo "join channel 2 ..."
    pushd ./vm2/
    ./joinChannel.sh $2
    popd
    echo "Channel joined in 2"
}
join3(){
    echo "join channel 3 ..."
    pushd ./vm3/
    ./joinChannel.sh $2
    popd
    echo "Channel joined in 3"
}


if [ $1 == "2" ]
then
    join2 $1 $2
fi
if [ $1 == "3" ]
then
    join3 $1 $2
fi


