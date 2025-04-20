import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:ohud/controllers/carousel_controller.dart' as my_carousel;

class MyCarousel extends StatelessWidget {
  const MyCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<my_carousel.MyCarouselController>(
      builder: (carouselController) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.8),
                itemCount: carouselController.imagePaths.length,
                onPageChanged: carouselController.setCurrentIndex,
                itemBuilder: (context, index) {
                  final isCurrent = index == carouselController.currentIndex.value;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    //   boxShadow: [
                    //     if (isCurrent)
                    //       BoxShadow(
                    //         color: Colors.black.withOpacity(0.2),
                    //         blurRadius: 8,
                    //         offset: const Offset(2, 2),
                    //       ),
                    //   ],
                    
                    ),
                    
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      
                      child: Transform.scale(
                        scale: isCurrent ? 1.0 : 0.9,
                        child: Image.asset(
                          carouselController.imagePaths[index],
                          fit: BoxFit.cover,
                          
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                carouselController.imagePaths.length,
                (index) {
                  final isCurrent = index == carouselController.currentIndex.value;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isCurrent ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isCurrent ? Colors.teal : Colors.teal.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
