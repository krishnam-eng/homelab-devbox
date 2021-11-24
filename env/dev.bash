# Build tools
if [ -d "$HOME/hrt/build/apache-maven-3.6.3" ]
then
  export M2_HOME="$HOME/hrt/build/apache-maven-3.6.3"
  PATH="${M2_HOME}/bin:${PATH}"
fi

if [ -d "$HOME/hrt/build/gradle-7.1.1" ]
then
  export GRADLE_HOME="~/hrt/build/gradle-7.1.1"
  PATH=${GRADLE_HOME}/bin:${PATH}
fi

# mac /usr/libexec/java_home -v gives the jre path (after big sur update) 
# So, set it to jdk for mvn to work
if [ -d /Library/Java/JavaVirtualMachines/jdk1.8.0_301.jdk/Contents/Home ]
then
  export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_301.jdk/Contents/Home"
  PATH="${JAVA_HOME}/bin:${PATH}"
fi

# IDE Path
if [ -d "$HOME/hrt/vscode/bin" ]
then
  PATH="$PATH:$HOME/hrt/vscode/bin"
fi

if [ -d "$HOME/hrt/ide/idea-2021/bin" ]
then
  PATH="$PATH:$HOME/hrt/ide/idea-2021/bin"
fi

if [ -d "$HOME/hrt/node/bin" ]
then
  PATH="$PATH:$HOME/hrt/node/bin"
fi

# use development mode as default for python flask project development
export FLASK_ENV=development

# keeping the default value for now
export FLASK_APP=app.py

# ES 1.7 expects ES JAVA HOME 
export ES_JAVA_HOME=$JAVA_HOME
export ES_HOME=$HOME/hrt/server/elasticsearch-7.15.2