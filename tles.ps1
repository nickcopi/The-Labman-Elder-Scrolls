#https://underthewire.tech/wargames.htm

Class Stage{
    [string] $question;
    [System.Collections.ArrayList] $options;
    Stage($question,$options){
        $this.question = $question;
        $this.options = New-Object -TypeName "System.Collections.ArrayList";
        $options | %{
            $this.options.Add($_);
        }
    }
    Stage($object){
        $this.question = $object.question;
        $this.options = New-Object -TypeName "System.Collections.ArrayList";
        $object.options | %{
            $this.options.Add((New-Object Option($_.value,$null)));
        }
    }
    [string] getOptionNames(){
        $names = '';
        $i = 1;
        $this.options | % {
            $names += $i.ToString() + ') ' + $_.value + "`n";
            $i++
        }
        return $names;
    }
}

Class Option{
    [string] $value;
    [Stage] $next;
    Option($value,$next){
        $this.value = $value;
        $this.next = $next;
    }
}
Class Game{
    [Ref] $start;
    [Ref] $currentStage;
    [Object] $stages;
    [Object] $data;
    Game(){
        $this.buildStages();
        $this.gameLoop();
    }
    [void] buildStages(){
        $this.data = Get-Content 'game.json' | ConvertFrom-JSON
        $stageNames = $this.data.PSObject.Properties.name;
        $this.stages =  New-Object -TypeName PSobject;
        $stageNames | %{
            $this.stages | Add-Member -MemberType NoteProperty  -Name $_ -Value ($this.data."$_");
        }
        $stageNames | %{
            $this.stages."$_".options | % {
                $next = $_.next;
                $_.next = $this.stages."$next";
            }
        }
        $this.start = $this.stages.start;
        $this.currentStage = $this.start;
    }
    [void] gameLoop(){
        while($this.currentStage.Value){
            [Stage] $stage = $this.currentStage.Value;
            Write-Host $stage.question;
            Write-Host $stage.getOptionNames();
            $selected = -1;
            do{
                $input = Read-Host 'What do you do?';
                $selected = $input -as [int];
            } while($selected -le 0 -or $selected -gt $stage.options.Count);
            $this.currentStage = $this.currentStage.Value.options[$selected-1].next;
        }
    }

}

#Write-Host ((New-Object Stage("It says ur dumb what do u do?",@(New-Object Option("cry",$null))))).options[0].value
$game = New-Object Game