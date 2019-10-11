#!/usr/bin/env bash
start() {
    mv "$HOME/.bashrc" "$HOME/.config/workflow/tmpbashrc"
    echo -e 'trap "" INT TSTP
echo "You are in a limited shell environment. The only command you can use is wfexit, which ends workflow mode."
while true; do
    read -p "[workflow-mode] > " -re command
    if [[ "$command" == "wfexit" ]]; then
        wfexit
    else
        echo "bash: $(echo $command | sed 's/[^ ]* *//g'): invalid command"
    fi
done' > "$HOME/.bashrc"
}
end() {
    mv "$HOME/.bashrc" "$HOME/.bashrc-workflow-bak"
    mv "$HOME/.config/workflow/tmpbashrc" "$HOME/.bashrc"
	source "$HOME/.bashrc"
}
