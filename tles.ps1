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
    [Stage] $start;
    [Stage] $currentStage;
    Game(){
        $this.buildStages();
        $this.gameLoop();
    }
    [void] buildStages(){
        $this.start = (New-Object Stage("It says ur dumb what do u do?",@((New-Object Option("cry",$null)),(New-Object Option("die",$null)))));
        $this.start = (New-Object Stage("I eat rocks.",@((New-Object Option("yes",$this.start)),(New-Object Option("no",$null)))));
        $this.currentStage = $this.start;
    }
    [void] gameLoop(){
        while($this.currentStage){
            Write-Host $this.currentStage.question;
            Write-Host $this.currentStage.getOptionNames();
            $selected = -1;
            do{
                $input = Read-Host 'What do you do?';
                $selected = $input -as [int];
            } while($selected -le 0 -or $selected -gt $this.currentStage.options.Count);
            $this.currentStage = $this.currentStage.options[$selected-1].next;
        }
    }

}

#Write-Host ((New-Object Stage("It says ur dumb what do u do?",@(New-Object Option("cry",$null))))).options[0].value
$game = New-Object Game