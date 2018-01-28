export GG_HOME=/u01/app/ogg
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib:$GG_HOME
export CLASSPATH=$ORACLE_HOME/jdk/jre:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
export PATH=$ORACLE_HOME/bin:$HOME/bin:$GG_HOME:$PATH
chmod +x gg*.kk
cp ./gg*.kk $GG_HOME
cd $GG_HOME
find -type f -name 'gg*.kk' | while read f; do mv "$f" "${f%.kk}"; done
echo "cd $GG_HOME"

