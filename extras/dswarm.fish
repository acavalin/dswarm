# from https://github.com/oh-my-fish/plugin-docker-machine/
function dswarm -a cmd -d 'Select a Docker context'
  switch "$cmd"
    case 'use'
      set -e argv[1]
      command dswarm context env   $argv fish --quiet | source
    case 'unset'
      command dswarm context unset       fish --quiet | source
    case '*'
      command dswarm $argv
      
      if not count $argv > /dev/null
        echo ""
        echo -e "### switch context (fish shell)"
        echo -e " use              <context-name>"
        echo -e " unset"
      end
  end
end
