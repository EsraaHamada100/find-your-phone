import 'package:flutter/material.dart';

class PhoneContainer extends StatelessWidget {
  PhoneContainer({required this.phoneType,required this.image, required this.IMME1, required this.IMME2,Key? key}) : super(key: key);
  String? image;
  String phoneType;
  String IMME1;
  String? IMME2;
  @override
  Widget build(BuildContext context) {
    return   Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(10),
        width: double.maxFinite,
        height: 120,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                // Color(0x7b3332a5),
                offset: Offset(-4, 4),
                blurRadius: 5,
                spreadRadius: 0)
          ],
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.2,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: image == null
                    ? Image.asset(
                  'assets/images/no_phone.jpg',
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        phoneType,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'IMME1 : $IMME1',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'sans'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        IMME2 != null
                            ? 'IMME2 : $IMME2'
                            : '',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'sans'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

