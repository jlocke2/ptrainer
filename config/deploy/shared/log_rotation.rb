<%= fetch(:deploy_to) %>/shared/log/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    sharedscripts
    endscript
    copytruncate
}