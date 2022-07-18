import 'package:flutter/material.dart';

class AdminContainer extends StatelessWidget {
  AdminContainer(
      {required this.id, required this.name, required this.email, Key? key})
      : super(key: key);
  String id;
  String name;
  String email;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(10),
      width: double.maxFinite,
      height: 310,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/user_logo.png',
              fit: BoxFit.fill,
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
                      name,
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
                      'email : $email',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(letterSpacing: 1.2),
                      // style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      //     color: Colors.black,
                      //     fontWeight: FontWeight.w400,
                      //     fontFamily: 'sans'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'id : $id',
                      // style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      //     color: Colors.black,
                      //     fontWeight: FontWeight.w400,
                      //     fontFamily: 'sans'),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(letterSpacing: 1.2),
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
