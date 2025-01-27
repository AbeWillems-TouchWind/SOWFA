#!/bin/bash

# Email credentials
FROM_EMAIL="sowfa.touchwind@gmail.com"
TO_EMAIL="TouchWindserver@touchwind.org"
SMTP_SERVER="smtp.gmail.com:587"
USERNAME="sowfa.touchwind@gmail.com"
PASSWORD="zofqirzlwqpeharp"

# Path to job queue file
JOB_QUEUE_PATH="/home/ubuntu/SOWFA/touchwindCases/job.queue"
SOWFA_PATH="/home/ubuntu/SOWFA/touchwindCases/"

# Flag to track if the initial email has been sent
initial_email_sent=false

# Variable to track the last idle email time
idle_email_interval=3600  # 1 hour in seconds
last_idle_email_time=$(date +%s)  # Initialize with the current time

cd $SOWFA_PATH
while true; do
    current_time=$(date +%s)
    
    # Check if there are any jobs in the queue
    if [ -s "$JOB_QUEUE_PATH" ]; then
        # Send initial start email only once when a job is found
        if [ "$initial_email_sent" = false ]; then
            sendemail -f "$FROM_EMAIL" -t "$TO_EMAIL" -u "STARTING Simulations On Server" -m "Starting queued simulations on the server." -s "$SMTP_SERVER" -o tls=yes -xu "$USERNAME" -xp "$PASSWORD"
            initial_email_sent=true
        fi

        # Get the first job from the queue
        NAME=$(head -n 1 "$JOB_QUEUE_PATH" | tr -d '\r')

        # Run the job
        echo "##### Running $NAME #####"
        cd ./$NAME
        chmod u+rwx ./runscript.complete
        ./runscript.complete
        cd ..

        # Remove the job from the queue
        sed -i '1d' "$JOB_QUEUE_PATH"

        # Reset the last idle email time after completing a job
        last_idle_email_time=$(date +%s)

        # Get remaining job count
        remaining_jobs=$(wc -l < "$JOB_QUEUE_PATH")

        # Send progress email with remaining job count
        sendemail -f "$FROM_EMAIL" -t "$TO_EMAIL" -u "PROGRESS Simulation On Server" -m "The simulation named \"$NAME\" has completed. There are $remaining_jobs simulations left in the queue." -s "$SMTP_SERVER" -o tls=yes -xu "$USERNAME" -xp "$PASSWORD"

        # Small delay before checking for the next job
        sleep 10

        # Check if all jobs are complete after each job is finished
        if [ ! -s "$JOB_QUEUE_PATH" ]; then
            sendemail -f "$FROM_EMAIL" -t "$TO_EMAIL" -u "FINISHED Simulations On Server" -m "All simulations on the server have been completed. You can safely turn the server off now." -s "$SMTP_SERVER" -o tls=yes -xu "$USERNAME" -xp "$PASSWORD"
            initial_email_sent=false  # Reset flag so "STARTING" email can be sent next time jobs are added
        fi
    else
        # Send an email if the server is idle and enough time has passed since the last idle email
        if [ $((current_time - last_idle_email_time)) -ge $idle_email_interval ]; then
            sendemail -f "$FROM_EMAIL" -t "$TO_EMAIL" -u "IDLE Server Warning" -m "The server has been idle for an hour. You can turn it off to save resources." -s "$SMTP_SERVER" -o tls=yes -xu "$USERNAME" -xp "$PASSWORD"
            last_idle_email_time=$current_time  # Update the last idle email time
        fi
        
        # Reset the initial email flag when the queue is empty and no jobs are running
        initial_email_sent=false
        echo "No jobs found. Waiting for new jobs..."
        sleep 30
    fi
done