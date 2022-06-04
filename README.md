# Multiplayer Voxel RPG

## Organisation
> <a href="https://trello.com/b/2ESJdCaI/voxel" title="trello link">Trello</a>

# Rules for contributing to the game

## Godot version
This game is built on top of a custom version of godot. Download the latest one from this CI:
> <a href="https://github.com/Zennyth/voxel-engine/actions" title="Godot custom build">Godot</a>

## File architecture
```text
voxel/
├── resources/
│   ├── architecture/
│   └── assets/
├── scripts/
└── src/
    └── game/
        ├── .godot/
        ├── addons/
        ├── assets/
        ├── modules/
        ├── scenes/
        ├── script_templates/
        └── scripts/
```

Every resources not essential to the functionment of the game should be in the ```ressources``` folder. 
Everything related to the implemented in-game content should be in the ```src``` folder.

The ```assets```, ```scenes``` and ```scripts``` folders store content according to the separation rule. Each of these folders has to follow the following file architecture:  
> Example of the structure based on the separation rule:
> ```text
> src/
> └── assets/
>     ├── characters/
>     ├── environement/
>     ├── items/
>     └── terrain/
> ```

The ```addons``` folder stores every outside plugins used in the game.
> Example: **Voxel-Core**

The ```modules``` folder stores every custom plugins used in the game. Custom plugins don't follow the separation rule.
> Example: **Spells**

## Code guidelines

Syntax
- Node, Resources, Class and struct names PascalCase
- Constants, enums and macros CAPSLOCK_CASE
- Other names snake_case
- Events always prefix with ```_on```, ```_on_state_change```
- Prefer comments with # only
- Use ```script_templates/comments``` for large scripts