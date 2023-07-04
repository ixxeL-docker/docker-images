#!/bin/bash
POSITION=2
declare -A files
declare -a uniq_components

files=$(gh pr view 11 --json files --jq '.files.[].path')

IFS=$'\n' read -rd '' -a files_array <<<"$files"

for file in "${files_array[@]}"
do
    COMPONENT_NAME=$(echo ${file} | awk -F'/' -v nb="${POSITION}" '{print $nb}')
    if [[ ! " ${uniq_components[@]} " =~ " $COMPONENT_NAME " ]]; then
        # Ajoutez le nom du composant au tableau des composants uniques
        uniq_components+=("$COMPONENT_NAME")
    fi
done

for component in "${uniq_components[@]}"
do
    echo "Composant unique : $component"
    # Faites quelque chose avec chaque composant unique ici
done