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
        $this.options | % {
            $names += $_.value + "`n";
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
    buildStages(){
        $this.start = (New-Object Stage("It says ur dumb what do u do?",@(New-Object Option("cry",$null),New-Object Option("die",$null))));
        $this.currentStage = $this.start;
    }
    gameLoop(){
        while($true){
            Write-Host $this.currentStage.question;
            Write-Host $this.currentStage.getOptionNames();
            $input = Read-Host 'What do you do?';
        }
    }

}

#Write-Host ((New-Object Stage("It says ur dumb what do u do?",@(New-Object Option("cry",$null))))).options[0].value
$game = New-Object Game