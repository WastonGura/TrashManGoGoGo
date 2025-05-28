class_name PlayerControl extends Node2D

@export var player: Player

const FlashATK:int = 100
const AngleATK:int = 60
const StarsATK:int = 40
const RemoteATK:int = 30
const NormalATK:int = 20
const ShieldDEF:int = 50
const PotDEF:int = 10
const NormalDEF:int = 0

const HURTFORCE := 100.0
const RUNSPEED := 600.0
const FLYRUNSPEED := 400.0
const DEFENDRUNSPEED := 50.0
const JUMPFORCE := 900.0
const GRAVITY := 2000.0
const FLYPFORCE := 1200.0
const FLYGRAVITY := 900.0
const SKILLGRAVITY := 0.0
const FLY_GRAVITY_DURATION := 2.0
const ATTACK_LOCK_DURATION := 1
const SKILL_LOCK_DURATION := 5

var jump_force: float
var run_speed: float
var gravity: float

var can_parry: bool
var can_skill: bool
var can_fly: bool
var can_run: bool
var can_control: bool = true
var can_close_attack: bool
var can_defend: bool
var can_remote_attack: bool
var can_jump: bool
var has_pet: bool = true
var has_touch: bool = false

var close_attack_locker: float = 0.0
var skill_locker: float = 0.0
var jump_locker: float = 0.0
var defend_locker: float = 0.0

var skill_cosume: int = 50
var defend_cosume: int = 5
var parry_cosume: int = 30
var parry_get: int = 10

var create_position = [Vector2(350,500), Vector2(900,540), Vector2(2300, 600), Vector2(1320, 1050)]

var jump: bool
var die: bool = false
var burn: bool
var idle: bool
var is_flying: bool = true
var land: bool
var is_running: bool
var is_hurting: bool
var is_burning: bool
var is_landing: bool
var is_action: bool
var is_skilling: bool
var is_healing: bool = false

var start_defend: bool
var continue_defend: bool
var end_defend: bool
