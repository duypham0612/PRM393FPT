import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

/// Root Application Widget
class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Movie Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      home: const GenreScreen(),
    );
  }
}

/// Data Model representing a single Movie item
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

/// Main Interactive Screen Container
class GenreScreen extends StatefulWidget {
  const GenreScreen({Key? key}) : super(key: key);

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  // --- Sample Mock Data Base ---
  final List<Movie> _allMovies = const [
    Movie(
      title: 'The Dark Knight',
      year: 2008,
      genres: ['Action', 'Drama', 'Thriller'],
      posterUrl: 'https://images.unsplash.com/photo-1509281373149-e957c6296406?w=400&q=80',
      rating: 9.0,
    ),
    Movie(
      title: 'Spirited Away',
      year: 2001,
      genres: ['Animation', 'Adventure', 'Family'],
      posterUrl: 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=400&q=80',
      rating: 8.6,
    ),
    Movie(
      title: 'Inception',
      year: 2010,
      genres: ['Action', 'Sci-Fi', 'Thriller'],
      posterUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=400&q=80',
      rating: 8.8,
    ),
    Movie(
      title: 'Pulp Fiction',
      year: 1994,
      genres: ['Crime', 'Drama'],
      posterUrl: 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?w=400&q=80',
      rating: 8.9,
    ),
    Movie(
      title: 'Interstellar',
      year: 2014,
      genres: ['Adventure', 'Drama', 'Sci-Fi'],
      posterUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400&q=80',
      rating: 8.6,
    ),
    Movie(
      title: 'Parasite',
      year: 2019,
      genres: ['Drama', 'Thriller', 'Comedy'],
      posterUrl: 'https://images.unsplash.com/photo-1535498730771-e735b998cd64?w=400&q=80',
      rating: 8.5,
    ),
  ];

  // --- Complete List of Available Movie Genres ---
  final List<String> _availableGenres = const [
    'Action',
    'Adventure',
    'Animation',
    'Comedy',
    'Crime',
    'Drama',
    'Family',
    'Sci-Fi',
    'Thriller'
  ];

  // --- Filtering & Sorting State Properties ---
  String _searchQuery = '';
  final Set<String> _selectedGenres = {};
  String _selectedSort = 'A-Z';

  // --- Input Management Controller ---
  final TextEditingController _searchController = TextEditingController();

  /// Reset all criteria to their default values (Bonus Step)
  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedGenres.clear();
      _selectedSort = 'A-Z';
      _searchController.clear();
    });
  }

  /// Process filtering criteria and sort order outputs on computational ticks
  List<Movie> _getFilteredAndSortedMovies() {
    List<Movie> processedList = _allMovies.where((movie) {
      // 1. Text Search Filter (Case-Insensitive structural matching)
      final matchesSearch = movie.title.toLowerCase().contains(_searchQuery.toLowerCase());

      // 2. Genre Match Filter (Item must contain at least one of chosen genres)
      final matchesGenre = _selectedGenres.isEmpty ||
          movie.genres.any((genre) => _selectedGenres.contains(genre));

      return matchesSearch && matchesGenre;
    }).toList();

    // 3. Conditional Sorting Computations
    switch (_selectedSort) {
      case 'A-Z':
        processedList.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Z-A':
        processedList.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Year':
        processedList.sort((a, b) => b.year.compareTo(a.year)); // Newer movies first
        break;
      case 'Rating':
        processedList.sort((a, b) => b.rating.compareTo(a.rating)); // Higher ratings first
        break;
    }

    return processedList;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredMovies = _getFilteredAndSortedMovies();
    final double paddingValue = MediaQuery.of(context).size.width > 600 ? 24.0 : 16.0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Find a Movie',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          // Dynamic Badge showing selected filter parameters (Bonus Feature)
          if (_selectedGenres.isNotEmpty || _searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Chip(
                avatar: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    '${_selectedGenres.length + (_searchQuery.isNotEmpty ? 1 : 0)}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                label: const Text('Active Filters'),
                onDeleted: _clearFilters,
              ),
            )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingValue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // --- Lab 6.1 & 6.2: Search Bar Input Element ---
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search for movies by title...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // --- Lab 6.2: Genre Section with Wrap Widget ---
              const Text(
                'Filter by Genre',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _availableGenres.map((genre) {
                  final isSelected = _selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedGenres.add(genre);
                        } else {
                          _selectedGenres.remove(genre);
                        }
                      });
                    },
                    selectedColor: Theme.of(context).colorScheme.primaryContainer,
                    checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // --- Lab 6.2: Sort Controller Layout Bar ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing ${filteredMovies.length} movies',
                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      const Text('Sort By: ', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      DropdownButton<String>(
                        value: _selectedSort,
                        underline: Container(),
                        icon: const Icon(Icons.arrow_drop_down),
                        items: <String>['A-Z', 'Z-A', 'Year', 'Rating']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedSort = newValue;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // --- Lab 6.3: Responsive Multi-View Grid/List Content Box ---
              Expanded(
                child: filteredMovies.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.movie_creation_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No matching movies found.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _clearFilters,
                        child: const Text('Reset All Search Parameters'),
                      )
                    ],
                  ),
                )
                    : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // Adaptive Layout Breakpoint set strictly at 800px width limit
                    if (constraints.maxWidth < 800) {
                      // Phone Layout Variant: Single Column Linear List
                      return ListView.builder(
                        itemCount: filteredMovies.length,
                        padding: const EdgeInsets.only(bottom: 16),
                        itemBuilder: (context, index) {
                          return MovieCard(movie: filteredMovies[index]);
                        },
                      );
                    } else {
                      // Tablet & Desktop Web Variant: Dual Column Grid Matrix
                      return GridView.builder(
                        itemCount: filteredMovies.length,
                        padding: const EdgeInsets.only(bottom: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2.3, // Prevents overflow layout clipping
                        ),
                        itemBuilder: (context, index) {
                          return MovieCard(movie: filteredMovies[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Adaptive Movie Card Component (Uses LayoutBuilder internally for component responsiveness)
class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        color: Colors.white,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adaptive sub-element width control logic (Bonus Specification)
            final double posterWidth = constraints.maxWidth > 500 ? 140 : 100;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Network Poster Thumbnail Block
                Image.network(
                  movie.posterUrl,
                  width: posterWidth,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback visual safety structure when web networks are offline
                    return Container(
                      width: posterWidth,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, color: Colors.grey[600]),
                    );
                  },
                ),

                // Text Information Details Panel Block
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Release Year: ${movie.year}',
                              style: TextStyle(color: Colors.grey[600], fontSize: 13),
                            ),
                          ],
                        ),

                        // Internal sub-wrapped categorical badges display area
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Wrap(
                            spacing: 4,
                            runSpacing: 2,
                            children: movie.genres.take(2).map((genre) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  genre,
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        // Rating Stars Indicator (Bonus implementation)
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              movie.rating.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}