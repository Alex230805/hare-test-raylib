use fmt;
use os;
use io;
use rbind::*;
use types::c;
use strings;

export type StringBuilder = struct{
	string_len:size,
	buffer: *[1024]u8,
};

export type Col = enum {
	RED = 0,
	YELLOW,
	BROW,
	PURPLE
};

export type playerPos = struct {
	x: int,
	y: int,
};


export fn main() void = {
	let list = [
		"orange",
		"apple",
		"banana",
		"pieapple"
	];

	let list2 = [
		"one",
		"two",
		"three",
		"four",
		"five",
		"six"
	];

	for(let i=0z;i<len(list);i+=1){
		fmt::printf("Line {}: {}\n", i, list[i])!;
	};

	for (let elem:str .. list2){
		fmt::printf("{}\n", elem)!;
	};
	// opening file
	let d: str = "./test.txt";

	let window_name:str = "hare raylib";
	const file = os::open(d)!;
	defer io::close(file)!;

	// allocating dinamic and static buffer
	// static let buffer1: [512]u8 = [0...];
	
	let sb = read_file(d);

	io::write(os::stdout, sb.buffer[..sb.string_len])!; // print to stdout from 0 to size
	defer free(sb.buffer);

	
	fmt::println("Hello World!\n")!; // hello world
	
	raylib_test(window_name);
};



export fn read_file(path:str) StringBuilder = {
	//const n = io::read(file, buffer)! as size; //  read and get size  
	let buffer: *[1024]u8 = alloc([0...])!;
	fmt::printf("Opening {} ... \n", path)!;
	const file = os::open(path)!;
	defer io::close(file)!;
	let n = io::read(file, buffer)! as size;
	 
	let sb = StringBuilder{ string_len = n, buffer = buffer}; 
	return sb;
};


export fn raylib_test(name:str) void = {
	let width = 700;
	let height = 600;
	let wname: str = strings::concat(name, "\0") as str;
	let p = playerPos{x = width/2, y = height/2};
	init_window(700, 600, c::nulstr(wname));	
	let velocity = 1;
	set_target_fps(60);
	for(!window_should_close()){
		begin_drawing();
		clear_background(Color{r = 30, g = 30, b = 30, a = 30});
		let frame_time:int = (get_frame_time()*1000.0): int;
		fmt::printf("Frame time: {}\n", frame_time)!;
		fmt::printf("Velocity: {}\n", velocity)!;
		fmt::printf("Player Pos: {} {}\n", p.x, p.y)!;
		
		if(is_key_released(KeyboardKey::KEY_ZERO)){
			velocity += 10;
		}else if(is_key_released(KeyboardKey::KEY_ONE)){
			velocity -= 10;
		}else if(is_key_down(KeyboardKey::KEY_W)){
			p.y -= (10 * velocity) / frame_time;
		}else if(is_key_down(KeyboardKey::KEY_S)){
			p.y += (10 * velocity) / frame_time;
		}else if(is_key_down(KeyboardKey::KEY_D)){
			p.x += (10 * velocity) / frame_time;
		}else if(is_key_down(KeyboardKey::KEY_A)){
			p.x -= (10 * velocity) / frame_time;
		};
		
		draw_rectangle(p.x, p.y, 50, 50, Color{r = 255,g = 255,b = 255,a = 255});
		end_drawing();
	};
	close_window();
	return;
};



@init fn init() void = {
	fmt::printf("Initializing stuff before main execution\n")!;
	return;
};


@fini fn end() void = {
	fmt::printf("End execution\n")!;
};
