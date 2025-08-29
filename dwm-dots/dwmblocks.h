//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{"", "echo 'Apps'", 0, 0},  // System tray placeholder
    {"| ", "setxkbmap -print | grep xkb_symbols | awk -F'[+:]' '{for(i=1;i<=NF;i++) if($i~/^(us|ru)$/) print toupper($i)}' | tail -1", 1, 9},
	{"vol:", "pamixer --get-volume | sed 's/$/%%/'", 1, 10}, 
	{"bright:", "xbacklight -get | cut -d'.' -f1 | sed 's/$/%%/'", 2, 11},
	{"bat:", "cat /sys/class/power_supply/BAT*/capacity | sed 's/$/%%/'", 60, 12},  
	{"cpu:", "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1\"%\"}'", 5, 13}, 
	{"mem:", "free -h | awk '/^Mem/ { print $3\"/\"$2 }' | sed s/i//g", 30, 0}, 
	{"", "date '+%b %d (%a) %I:%M%p'", 5, 0}, 
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 5;

{"⌨️", "setxkbmap -print | grep xkb_symbols | awk -F'[+:]' '{for(i=1;i<=NF;i++) if($i~/^(us|ru)$/) print toupper($i)}' | tail -1", 1, 9},  