#/bin/bash

launcher(){
  echo;wget "TermUi" "https://raw.githubusercontent.com/strangecode4u/TermUi/main/TermUi.sh";
  if [[ "${?}" == 0 ]]; then
    mv "TermUi" "${PREFIX}/bin/";
    chmod +x "${PREFIX}/bin/TermUi";
    echo;echo "TermUi";echo;exit;
  else echo;exit;
  fi
}
launcher