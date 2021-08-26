enum Ensure {
    Absent
    Present
}

[DscResource()]
class classFeature {


    [DscProperty(Key)]
    [string] $FeatureName

    [DscProperty()]
    [Ensure] $Ensure
    
    # Gets the resource's current state.
    [classFeature] Get() {
        $status = Get-WindowsFeature -Name $this.FeatureName
        switch ($status.InstallState) {
            "Installed" { $this.Ensure = [Ensure]::Present }
            default { $this.Ensure = [Ensure]::Absent }
        }
        return $this
    }
    
    # Sets the desired state of the resource.
    [void] Set() {
        Install-WindowsFeature -Name $this.FeatureName -Verbose -Force
    }
    
    # Tests if the resource is in the desired state.
    [bool] Test() {
        $status = Get-WindowsFeature -Name $this.FeatureName
        if ($status.Installed) {
            return $true
        }
        else { 
            return $false 
        }
    }
}