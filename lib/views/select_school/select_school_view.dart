import 'package:flutter/material.dart';
import 'package:school_id_collect/views/stud_info/student_info_view.dart';

class SelectSchoolView extends StatefulWidget {
  const SelectSchoolView({super.key});

  @override
  State<SelectSchoolView> createState() => _SelectSchoolViewState();
}

class _SelectSchoolViewState extends State<SelectSchoolView> {
  final TextEditingController searchController = TextEditingController();

  int? selectedIndex;

  final List<Map<String, dynamic>> schools = [
    {
      "name": "Delhi Public School",
      "address": "123 Main Street, New York",
      "distance": "2.4 km away",
      "reviews": "127 Reviews",
      "rating": 5.0,
      "image":
      "https://images.unsplash.com/photo-1509062522246-3755977927d7?w=500",
    },
    {
      "name": "ABC School",
      "address": "45 Park Avenue, California",
      "distance": "3.1 km away",
      "reviews": "98 Reviews",
      "rating": 5.0,
      "image":
      "https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=500",
    },
  ];

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {});
    });
  }

  List<Map<String, dynamic>> get filteredSchools {
    if (searchController.text.isEmpty) {
      return schools;
    }

    return schools.where((school) {
      return school["name"]
          .toString()
          .toLowerCase()
          .contains(searchController.text.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text("Select School"),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search school name...",
                  prefixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400, // Normal state border
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Colors.black, // Selected/focused state border
                      width: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredSchools.length,
                  itemBuilder: (context, index) {
                    final school = filteredSchools[index];

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child:


                      Container(
                        margin: const EdgeInsets.only(bottom: 16),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),

                          border: Border.all(
                            color: selectedIndex == index
                                ? Colors.teal
                                : Colors.grey.shade400,
                            width: selectedIndex == index ? 2 : 1,
                          ),
                        ),

                        child: LayoutBuilder(
                          builder: (context, constraints) {

                            final imageSize = constraints.maxWidth < 350 ? 70.0 : 90.0;


                            return Padding(
                              padding: const EdgeInsets.all(12),

                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      school["image"],
                                      width: imageSize,
                                      height: imageSize,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          width: imageSize,
                                          height: imageSize,
                                          color: Colors.grey.shade200,
                                          child: Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.grey.shade400,
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                    (loadingProgress.expectedTotalBytes ?? 1)
                                                    : null,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: imageSize,
                                          height: imageSize,
                                          color: Colors.grey.shade200,
                                          child: Icon(
                                            Icons.school,
                                            size: imageSize * 0.5,
                                            color: Colors.grey.shade400,
                                          ),
                                        );
                                      },
                                    ),
                                  ),


                                  const SizedBox(width: 12),



                                  Expanded(
                                    child: Column(

                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                      children: [

                                        Text(
                                          school["name"],

                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,

                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),



                                        const SizedBox(height: 6),



                                        Text(
                                          school["address"],

                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,

                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),



                                        const SizedBox(height: 6),



                                        Text(
                                          school["distance"],

                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),



                                        const SizedBox(height: 8),



                                        Wrap(
                                          crossAxisAlignment:
                                          WrapCrossAlignment.center,

                                          spacing: 2,

                                          children: [

                                            const Icon(
                                              Icons.star,
                                              size: 18,
                                              color: Color(0xff1B827C),
                                            ),

                                            const Icon(
                                              Icons.star,
                                              size: 18,
                                              color: Color(0xff1B827C),
                                            ),

                                            const Icon(
                                              Icons.star,
                                              size: 18,
                                              color: Color(0xff1B827C),
                                            ),

                                            const Icon(
                                              Icons.star,
                                              size: 18,
                                              color: Color(0xff1B827C),
                                            ),

                                            const Icon(
                                              Icons.star,
                                              size: 18,
                                              color: Color(0xff1B827C),
                                            ),


                                            const SizedBox(width: 8),


                                            Text(
                                              school["reviews"],

                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),



                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),

                                ],
                              ),
                            );
                          },
                        ),
                      )
                    );
                  },
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: selectedIndex == null
                      ? null
                      : () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentInfoView(
                          school: filteredSchools[selectedIndex!],
                        ),
                      ),
                    );
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff038D76),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18,
                      color: selectedIndex == null
                          ? Colors.grey
                          : Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }


}
