param (
    [string[]]$vmNames,
    [string]$resourceGroupName
)

foreach ($vmName in $vmNames) {
    # Desalocar a VM
    Stop-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Force -NoWait

    # Aguardar alguns segundos para garantir que a VM foi completamente desalocada
    Start-Sleep -Seconds 10

    # Realocar a VM
    Start-AzVM -ResourceGroupName $resourceGroupName -Name $vmName
}

# Obter os novos IPs públicos
foreach ($vmName in $vmNames) {
    $vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName
    $ipConfig = $vm.NetworkProfile.NetworkInterfaces[0].IpConfigurations[0]
    $publicIP = (Get-AzPublicIpAddress -ResourceGroupName $resourceGroupName -Name $ipConfig.PublicIpAddress.Id.Split('/')[-1])
    Write-Output "$vmName - Novo IP Público: $($publicIP.IpAddress)"
}
