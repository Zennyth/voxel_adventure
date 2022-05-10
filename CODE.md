# Rules for contributing to the game

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
>     ├── terrain/
>     └── terrain/
> ```

The ```addons``` folder store every outside plugins used in the game.
> Example: **Voxel-Core**

The ```modules``` folder store every custom plugins used in the game. Custom plugins doesn't follow the separation rule.
> Example: **Spells**

## Code guidelines

Syntax
- Class and struct names PascalCase
- Constants, enums and macros CAPSLOCK_CASE
- Other names snake_case
- Prefer comments with # only