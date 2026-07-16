import 'package:flutter/material.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        height: 170,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFFFF3DC),
          border: Border.all(color: Color(0xFF1B4332), width: 0.3),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned(
                bottom: -60,
                left: -40,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFAC775).withOpacity(0.35),
                  ),
                ),
              ),
              Positioned(
                top: -20,
                left: 130,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFAC775).withOpacity(0.2),
                  ),
                ),
              ),

              // Content
              Positioned(
                left: 20,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag pill
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFEF9F27),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "TODAY'S PICK",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF412402),
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    // Title
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF412402),
                          height: 1.3,
                        ),
                        children: [
                          TextSpan(text: 'Cook the '),
                          TextSpan(
                            text: 'best',
                            style: TextStyle(color: Color(0xFF854F0B)),
                          ),
                          TextSpan(text: '\nrecipes today!'),
                        ],
                      ),
                    ),
                    SizedBox(height: 14),

                    // Button
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF412402),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Explore',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFF3DC),
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward,
                            size: 13,
                            color: Color(0xFFFFF3DC),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Chef image
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: Image.asset(
                  'images/image.png',
                  width: 130,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

