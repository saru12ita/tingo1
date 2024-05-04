import 'package:flutter/material.dart';

void main() {
  runApp(RecipeSharingApp());
}

class RecipeSharingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Sharing',
      theme: ThemeData(
        primaryColor: Colors.green,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.orangeAccent),
        scaffoldBackgroundColor:
            Color(0xFFFAFAFA), // Light gray background color
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RecipeListScreen(),
    );
  }
}

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final List<Recipe> recipes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return RecipeCard(
            recipe: recipes[index],
            toggleFavorite: () {
              setState(() {
                recipes[index].isFavorite = !recipes[index].isFavorite;
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRecipeScreen(
                onRecipeAdded: (newRecipe) {
                  setState(() {
                    recipes.add(newRecipe);
                  });
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Recipe {
  final String name;
  final Duration prepTime;
  final int serves;
  final List<Ingredient> ingredients;
  final List<String> instructions;
  bool isFavorite;

  Recipe({
    required this.name,
    required this.prepTime,
    required this.serves,
    required this.ingredients,
    required this.instructions,
    this.isFavorite = false,
  });
}

class Ingredient {
  final String name;
  final double price;

  Ingredient({required this.name, required this.price});
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback toggleFavorite;

  RecipeCard({required this.recipe, required this.toggleFavorite});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  recipe.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: recipe.isFavorite ? Colors.red : null,
                  ),
                  onPressed: toggleFavorite,
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Prep Time: ${recipe.prepTime.inMinutes} mins',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              'Serves: ${recipe.serves}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.ingredients
                  .map((ingredient) => Text(
                      '${ingredient.name}: \$${ingredient.price.toStringAsFixed(2)}'))
                  .toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Instructions:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.instructions
                  .map((instruction) => Text(instruction))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class AddRecipeScreen extends StatefulWidget {
  final Function(Recipe) onRecipeAdded;

  AddRecipeScreen({required this.onRecipeAdded});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _prepTimeController = TextEditingController();
  TextEditingController _servesController = TextEditingController();
  List<TextEditingController> _ingredientControllers = [];
  TextEditingController _instructionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green, Colors.yellow[100]!],
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Recipe Name',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter recipe name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _prepTimeController,
                  decoration: InputDecoration(
                    labelText: 'Prep Time (minutes)',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter prep time';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _servesController,
                  decoration: InputDecoration(
                    labelText: 'Serves',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of serves';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Ingredients:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                // Add ingredient input fields dynamically
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _ingredientControllers.length,
                  itemBuilder: (context, index) {
                    return TextFormField(
                      controller: _ingredientControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Ingredient ${index + 1}',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter ingredient ${index + 1}';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _ingredientControllers.add(TextEditingController());
                    });
                  },
                  child: Text('Add Ingredient'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _instructionsController,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Instructions',
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter instructions';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Recipe newRecipe = Recipe(
                        name: _nameController.text,
                        prepTime: Duration(
                            minutes: int.parse(_prepTimeController.text)),
                        serves: int.parse(_servesController.text),
                        ingredients: _ingredientControllers.map((controller) {
                          return Ingredient(name: controller.text, price: 0.0);
                        }).toList(),
                        instructions: [_instructionsController.text],
                      );
                      widget.onRecipeAdded(newRecipe);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Add Recipe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
