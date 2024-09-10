#!/bin/bash

# Detect OS for date command compatibility
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    date_command="date -d"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    date_command="date -jf %Y-%m-%dT%H:%M:%S"
else
    echo "Unsupported OS"
    exit 1
fi

# Function to get current date
get_date() {
    echo $(date '+%Y-%m-%d %H:%M:%S')
}

# Function to sanitize timestamp (removing extraneous characters)
sanitize_timestamp() {
    # Remove fractional seconds and time zone info
    echo "$1" | sed -E 's/\.[0-9]{6}[\+|-][0-9]{2}:[0-9]{2}//'
}

# Function to calculate uptime in days, hours, and minutes
calculate_uptime() {
    start_time=$(sanitize_timestamp "$1")
    current_time=$(date -u +"%Y-%m-%dT%H:%M:%S")

    # Convert start and current times to seconds since the epoch
    if [[ "$OSTYPE" == "darwin"* ]]; then
        start_seconds=$(date -jf "%Y-%m-%dT%H:%M:%S" "$start_time" +%s)
        current_seconds=$(date -jf "%Y-%m-%dT%H:%M:%S" "$current_time" +%s)
    else
        start_seconds=$(date -d "$start_time" +%s)
        current_seconds=$(date -d "$current_time" +%s)
    fi

    # Calculate uptime in seconds
    uptime_seconds=$((current_seconds - start_seconds))

    # Convert uptime to days, hours, and minutes
    days=$(($uptime_seconds / 86400))
    hours=$((($uptime_seconds % 86400) / 3600))
    minutes=$((($uptime_seconds % 3600) / 60))

    echo "$days days, $hours hours, $minutes minutes"
}

# Function to fetch ECS task details, including AZ and uptime
get_ecs_task_info() {
    current_date=$(get_date)

    # Get all ECS cluster ARNs
    ecs_clusters=$(aws ecs list-clusters --query 'clusterArns' --output text)
    
    if [ -z "$ecs_clusters" ]; then
        return
    fi

    # Iterate through each ECS cluster
    for cluster_arn in $ecs_clusters; do
        cluster_name=$(basename $cluster_arn)

        # Get running tasks for each ECS cluster
        ecs_task_arns=$(aws ecs list-tasks --cluster "$cluster_arn" --desired-status RUNNING --query 'taskArns' --output text)
        
        if [ -z "$ecs_task_arns" ]; then
            continue
        fi
        
        # Get details of each task
        ecs_tasks=$(aws ecs describe-tasks --cluster "$cluster_arn" --tasks $ecs_task_arns --query 'tasks[*]')

        # Iterate over each ECS task to get task details
        for task_arn in $ecs_task_arns; do
            task_details=$(aws ecs describe-tasks --cluster "$cluster_arn" --tasks "$task_arn")
            launch_type=$(echo "$task_details" | jq -r '.tasks[0].launchType')

            if [[ "$launch_type" == "FARGATE" ]]; then
                # Fargate Task
                eni_id=$(echo "$task_details" | jq -r '.tasks[0].attachments[0].details[] | select(.name == "networkInterfaceId") | .value')
                az=$(aws ec2 describe-network-interfaces --network-interface-ids "$eni_id" --query 'NetworkInterfaces[*].AvailabilityZone' --output text)
                start_time=$(echo "$task_details" | jq -r '.tasks[0].createdAt')
                uptime=$(calculate_uptime "$start_time")
                echo "$current_date, ECS (Fargate), $cluster_name (Task $task_arn), $az, Uptime: $uptime"
            else
                # EC2-backed Task
                ec2_instance_id=$(echo "$task_details" | jq -r '.tasks[0].containerInstanceArn')
                ec2_instance_id=$(aws ecs describe-container-instances --cluster "$cluster_arn" --container-instances "$ec2_instance_id" --query 'containerInstances[0].ec2InstanceId' --output text)
                az=$(aws ec2 describe-instances --instance-ids "$ec2_instance_id" --query 'Reservations[*].Instances[*].Placement.AvailabilityZone' --output text)
                start_time=$(echo "$task_details" | jq -r '.tasks[0].startedAt')
                uptime=$(calculate_uptime "$start_time")
                echo "$current_date, ECS (EC2), $cluster_name (Task $task_arn, Instance $ec2_instance_id), $az, Uptime: $uptime"
            fi
        done
    done
}

# Function to fetch RDS instance AZ and uptime
get_rds_az_info() {
    current_date=$(get_date)

    # Get all RDS instance identifiers
    rds_instances=$(aws rds describe-db-instances --query 'DBInstances[*].DBInstanceIdentifier' --output text)
    
    if [ -z "$rds_instances" ]; then
        return
    fi

    # Iterate through each RDS instance
    for rds_instance in $rds_instances; do
        az=$(aws rds describe-db-instances --db-instance-identifier "$rds_instance" --query 'DBInstances[*].AvailabilityZone' --output text)
        instance_creation_time=$(aws rds describe-db-instances --db-instance-identifier "$rds_instance" --query 'DBInstances[*].InstanceCreateTime' --output text | tr -d '"')
        uptime=$(calculate_uptime "$instance_creation_time")
        echo "$current_date, RDS, $rds_instance, $az, Uptime: $uptime"
    done
}

# Main script execution
echo "Date, Resource Type, Resource Name, AZ Location, Uptime"
get_ecs_task_info
get_rds_az_info
