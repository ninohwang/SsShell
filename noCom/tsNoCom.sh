HdlPathBySed='s/((\/)(\/)+)/\2/g'

p1=$( echo ///hello/path//sub///ext | sed -r $HdlPathBySed )
echo $p1

HdlPathBySedPro='s/^(\/)*|((\/)(\/)+)/\3/g'
p2=$( echo ///sun//moon//day///time | sed -r $HdlPathBySedPro)
echo $p2
