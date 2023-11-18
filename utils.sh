#!/usr/bin/env bash

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
else
    echo ".env file not found"
    exit 1
fi

# Function to dump remote MySQL database
dump_database() {
    local db_host=$1
    local db_user=$2
    local db_pass=$3
    local db_name=$4
    local dump_file=$5

    echo "Dumping database ${db_name} from ${db_host}"
    mysqldump -h ${db_host} -u ${db_user} -p${db_pass} ${db_name} > ${dump_file}
}

# Function to import MySQL database
import_database() {
    local db_name=$1
    local dump_file=$2

    # Check if the database exists
    if ! mysql -h 127.0.0.1 -u root -e "use ${db_name}"; then
        echo "Database ${db_name} does not exist. Creating database."
        mysql -h 127.0.0.1 -u root -e "CREATE DATABASE IF NOT EXISTS ${db_name}"
    fi

    echo "Importing database ${db_name} from ${dump_file}"
    mysql -h 127.0.0.1 -u root ${db_name} < ${dump_file}
}

# Menu for selecting action
PS3=$(echo -e "\nPlease enter your choice: ")
options=("Dump remote API DB" "Dump remote CMS DB" "Import Remote API DB Dump to Local" "Import Remote CMS DB Dump to Local" "Test Services" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Dump remote API DB")
            if [ ! -z "${REMOTE_API_DB_HOST}" ]; then
                API_DUMP_FILE="mysql/api_dump.sql"
                dump_database "${REMOTE_API_DB_HOST}" "${REMOTE_API_DB_USER}" "${REMOTE_API_DB_PASS}" "${REMOTE_API_DB_NAME}" "${API_DUMP_FILE}"
            fi
            break
            ;;

        "Dump remote CMS DB")
            if [ ! -z "${REMOTE_CMS_DB_HOST}" ]; then
                CMS_DUMP_FILE="mysql/cms_dump.sql"
                dump_database "${REMOTE_CMS_DB_HOST}" "${REMOTE_CMS_DB_USER}" "${REMOTE_CMS_DB_PASS}" "${REMOTE_CMS_DB_NAME}" "${CMS_DUMP_FILE}"
            fi
            break
            ;;

        "Import Remote API DB Dump to Local")
            if [ -f "mysql/api_dump.sql" ]; then
                import_database "${REMOTE_API_DB_NAME}" "mysql/api_dump.sql"
            fi
            break
            ;;

        "Import Remote CMS DB Dump to Local")
            if [ -f "mysql/cms_dump.sql" ]; then
                import_database "${REMOTE_CMS_DB_NAME}" "mysql/cms_dump.sql"
            fi
            break
            ;;
        "Test Services")
            echo -e "\n\033[36mTesting MySQL\033[0m"
            nc -zv 127.0.0.1 3306
            echo -e "\n\033[36mTesting Redis\033[0m"
            nc -zv 127.0.0.1 6379
            echo -e "\n\033[36mTesting PHP-FPM\033[0m"
            nc -zv 127.0.0.1 9000
            echo -e "\n\033[36mTesting Nginx\033[0m"
            nc -zv 127.0.0.1 80
            break
            ;;    
        "Quit")
            break
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done
