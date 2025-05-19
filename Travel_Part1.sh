#!/bin/bash

DATA_FILE="destinations.txt"
if [ ! -f "$DATA_FILE" ]; then
echo "File $DATA_FILE not found!"
exit 1
fi

read -p "Enter number of adults: " adults

if ! [[ "$adults" =~ ^[0-9]+$ ]]; then
echo "Please enter a valid number."
exit 1
fi

if [ "$adults" -gt 9 ]; then
group="Adults > 9"
else
group="Adults ≤ 9"
fi

echo "Choose budget level:"
echo "1) Low"
echo "2) Medium"
echo "3) High"
read -p "Enter option (1-3): " budget_choice

case $budget_choice in
1) budget="Low";;
2) budget="Medium";;
3) budget="High";;
*) echo "Invalid budget choice." ; exit 1;;
esac

echo ""
echo "Searching for $budget budget destinations for group: $group..."
echo ""

print=0
while read -r line; do
if [[ "$line" =~ "## $group" ]]; then
print=1
continue
fi
if [[ "$line" =~ "##" && ! "$line" =~ "$group" ]]; then
print=0
fi
if [ $print -eq 1 ]; then
dest_budget=$(echo "$line" | awk -F '-' '{print $NF}' | xargs)
if [ "$dest_budget" == "$budget" ]; then
echo "- $(echo "$line" | cut -d'-' -f1 | xargs)"
fi
fi
done < "$DATA_FILE"

