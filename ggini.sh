export GG_HOME=/u01/app/ogg
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib:$GG_HOME
export CLASSPATH=$ORACLE_HOME/jdk/jre:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
export PATH=$ORACLE_HOME/bin:$HOME/bin:$GG_HOME:$PATH
chmod +x gg*
cp ./gg* $GG_HOME
cd $GG_HOME
mv gg*.kk gg*
./ggsci
