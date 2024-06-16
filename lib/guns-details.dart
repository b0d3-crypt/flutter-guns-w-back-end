import 'package:flutter/material.dart';
import 'package:gun_store/gun_model.dart';

import 'comments.dart';

class GunsDetails extends StatefulWidget {
  final Gun gun;

  GunsDetails({required this.gun});

  @override
  _GunsDetailsState createState() => _GunsDetailsState();
}

class _GunsDetailsState extends State<GunsDetails> {
  bool isExpanded = false;
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gun.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.asset(
                        widget.gun.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.gun.name,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                liked = !liked;
                              });
                            },
                            child: Icon(
                              liked ? Icons.favorite : Icons.favorite_border,
                              color: liked ? Colors.red : null,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isExpanded
                                ? widget.gun.description
                                : (widget.gun.description.length > 100
                                    ? '${widget.gun.description.substring(0, 100)}...'
                                    : widget.gun.description),
                            style: TextStyle(fontSize: 18),
                          ),
                          if (widget.gun.description.length > 100)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    isExpanded ? 'Menos' : 'Mais',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  Icon(
                                    isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 400,
                child: Comments(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
