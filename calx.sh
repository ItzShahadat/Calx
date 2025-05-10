#!/data/data/com.termux/files/usr/bin/bash

month=$(date +%m)
year=$(date +%Y)
today=$(date +%d)
theme="dark"
events_file=".calx_events"

# Function: Draw Calendar
draw_calendar() {
    clear

    echo -e "\e[1;36m===========================\n        CalX - Bash        \n===========================\e[0m"
    echo -e "Month: $month | Year: $year | Theme: $theme"

    echo -e "\n\e[1;33m Mo Tu We Th Fr Sa Su\e[0m"
    echo "-----------------------------------"

    cal_output=$(cal $month $year)

    while IFS= read -r line; do
        if [[ $line == *"$today"* && $month == $(date +%m) && $year == $(date +%Y) ]]; then
            echo "$line" | sed "s/\b$today\b/[\e[1;41m$today\e[0m]/g"
        else
            echo "$line"
        fi
    done <<< "$(echo "$cal_output" | tail -n +2)"

    echo "-----------------------------------"
    echo -e "[n] Next | [p] Prev | [j] Jump | [t] Theme | [e] Events | [q] Quit"
}

# Toggle theme
toggle_theme() {
    if [ "$theme" = "dark" ]; then
        theme="light"
    else
        theme="dark"
    fi
}

# Add/View/Delete Events
manage_events() {
    echo -e "Enter event command: add/view/delete"
    read action
    case "$action" in
        add)
            echo "Enter event date (DD/MM/YYYY):"
            read event_date
            echo "Enter event description:"
            read event_desc
            echo "$event_date - $event_desc" >> $events_file
            ;;
        view)
            cat $events_file
            ;;
        delete)
            echo "Enter event line number to delete:"
            read line_num
            sed -i "${line_num}d" $events_file
            ;;
        *)
            echo "Invalid action!"
            ;;
    esac
}

# Main Loop
while true; do
    draw_calendar
    read -rsn1 key  # Read 1 key silently

    case "$key" in
        n)
            if [ "$month" -eq 12 ]; then
                month=1
                year=$((year + 1))
            else
                month=$((month + 1))
            fi
            ;;
        p)
            if [ "$month" -eq 1 ]; then
                month=12
                year=$((year - 1))
            else
                month=$((month - 1))
            fi
            ;;
        j)
            read -p "Enter Year (e.g. 2025): " new_year
            read -p "Enter Month (1-12): " new_month
            if [[ "$new_month" -ge 1 && "$new_month" -le 12 ]]; then
                year=$new_year
                month=$new_month
            else
                echo "Invalid month!"
                sleep 1
            fi
            ;;
        t)
            toggle_theme
            ;;
        e)
            manage_events
            ;;
        q)
            echo "Goodbye!"
            break
            ;;
        *)
            ;;
    esac
done
