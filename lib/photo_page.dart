import 'dart:math';
import 'package:flutter/material.dart';

enum PhotoType { dog, landscapes }

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  String? _imageUrl;
  bool _isLoading = false;
  String? _errorMessage;
  PhotoType _animalType = PhotoType.dog;

  // Список ваших локальных изображений (Шаг 9.4)
  final List<String> _images = [
    'assets/images/photo1.jpg',
    'assets/images/photo2.jpg',
    'assets/images/photo3.jpg',
    'assets/images/photo4.jpg',
  ];

  // Метод имитации загрузки локального фото
  Future<void> _fetchPhoto() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _imageUrl = null;
    });

    // Имитируем задержку сети в 1 секунду, чтобы увидеть крутилку (индикатор загрузки)
    await Future.delayed(const Duration(seconds: 1));

    try {
      if (_images.isEmpty) {
        throw Exception('Список изображений пуст');
      }
      
      // Выбираем случайную картинку из списка assets
      final random = Random();
      final randomIndex = random.nextInt(_images.length);
      
      setState(() {
        _imageUrl = _images[randomIndex];
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Не удалось загрузить фото.\nПроверьте файлы в папке assets/images/.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildAnimalToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('🐶 Собаки'),
          selected: _animalType == PhotoType.dog,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _animalType = PhotoType.dog;
                _imageUrl = null;
                _errorMessage = null;
              });
            }
          },
        ),
        const SizedBox(width: 12),
        ChoiceChip(
          label: const Text('🌄 Пейзаж'),
          selected: _animalType == PhotoType.landscapes,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _animalType = PhotoType.landscapes;
                _imageUrl = null;
                _errorMessage = null;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ),
        ),
      );
    }

    if (_imageUrl != null) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              _imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text(
                    'Ошибка: файл не найден.\nУбедитесь, что переименовали фото в photo1.jpg и т.д.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    return const Expanded(
      child: Center(
        child: Text(
          'Нажмите кнопку\nчтобы загрузить фото',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    String label = _animalType == PhotoType.dog ? '🐶 Новая собака' : '🌄 Новый пейзаж';

    return ElevatedButton(
      onPressed: _isLoading ? null : _fetchPhoto,
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фото дня'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildAnimalToggle(),
          const SizedBox(height: 20),
          _buildContent(),
          const SizedBox(height: 20),
          _buildButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
