#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root. Use sudo."
    exit 1
fi

# Display usage information
function display_usage {
    echo "Usage: $0 [OPTIONS]"
    echo "-c, --create    Create a new user account"
    echo "-d, --delete    Delete an existing user account"
    echo "-r, --reset     Reset password for an existing user account"
    echo "-l, --list      List all user accounts"
    echo "-h, --help      Help and usage information"
}

# Create a new user
function create_user {
    read -p "Enter a new username: " username

    if id "$username" &>/dev/null; then
        echo "Error: The username '$username' already exists. Please choose a different username."
    else
        read -s -p "Enter the password for $username: " password
        echo
        useradd -m "$username"
        echo "$username:$password" | chpasswd
        echo "User account '$username' created successfully."
    fi
}

# Delete a user
function delete_user {
    read -p "Enter a username to delete: " username

    if id "$username" &>/dev/null; then
        userdel -r "$username"
        echo "Username '$username' deleted successfully."
    else
        echo "Error: The username '$username' does not exist."
    fi
}

# Reset user password
function reset_password {
    read -p "Enter the username to reset password: " username

    if id "$username" &>/dev/null; then
        read -s -p "Enter the new password for $username: " password
        echo
        echo "$username:$password" | chpasswd
        echo "Password for user '$username' reset successfully."
    else
        echo "Error: The username '$username' does not exist."
    fi
}

# List all users
function list_users {
    echo "User accounts on the system:"
    awk -F: '{ print "- " $1 " (UID: " $3 ")" }' /etc/passwd
}

# Parse command-line arguments
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    display_usage
    exit 0
fi

while [ $# -gt 0 ]; do
    case "$1" in
        -c|--create)
            create_user
            ;;
        -d|--delete)
            delete_user
            ;;
        -r|--reset)
            reset_password
            ;;
        -l|--list)
            list_users
            ;;
        *)
            echo "Error: Invalid option '$1'. Use '--help' to see available options."
            exit 1
            ;;
    esac
    shift
done

