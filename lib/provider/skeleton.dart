import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

listViewSkeleton() {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    physics: NeverScrollableScrollPhysics(),
    itemCount: 6,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        height: 150,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[200],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: SkeletonAnimation(
                  shimmerColor: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  shimmerDuration: 1000,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 30, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
                      child: SkeletonAnimation(
                        borderRadius: BorderRadius.circular(10.0),
                        shimmerColor: Colors.white,
                        child: Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey[300]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
                      child: SkeletonAnimation(
                        borderRadius: BorderRadius.circular(10.0),
                        shimmerColor: Colors.white,
                        child: Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey[300]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: SkeletonAnimation(
                          borderRadius: BorderRadius.circular(10.0),
                          shimmerColor: Colors.white,
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey[300]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

gridViewSkeleton() {
  return GridView.builder(
    itemCount: 8,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 250,
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12),
    scrollDirection: Axis.vertical,
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[200],
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: SkeletonAnimation(
                  shimmerColor: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  shimmerDuration: 1000,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
                      child: SkeletonAnimation(
                        borderRadius: BorderRadius.circular(10.0),
                        shimmerColor: Colors.white,
                        child: Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey[300]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
                      child: SkeletonAnimation(
                        borderRadius: BorderRadius.circular(10.0),
                        shimmerColor: Colors.white,
                        child: Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey[300]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: SkeletonAnimation(
                          borderRadius: BorderRadius.circular(10.0),
                          shimmerColor: Colors.white,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey[300]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

statisticsSkeleton() {
  return ListView(
    children: [
      Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[200],
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: SkeletonAnimation(
                      borderRadius: BorderRadius.circular(10.0),
                      shimmerColor: Colors.white,
                      child: Container(
                        width: 50,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[300]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: SkeletonAnimation(
                      borderRadius: BorderRadius.circular(10.0),
                      shimmerColor: Colors.white,
                      child: Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[300]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: SkeletonAnimation(
                      shimmerColor: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      shimmerDuration: 1000,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: SkeletonAnimation(
                      shimmerColor: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      shimmerDuration: 1000,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: SkeletonAnimation(
                    borderRadius: BorderRadius.circular(10.0),
                    shimmerColor: Colors.white,
                    child: Container(
                      width: 100,
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[300]),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: SkeletonAnimation(
                    borderRadius: BorderRadius.circular(10.0),
                    shimmerColor: Colors.white,
                    child: Container(
                      width: 100,
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[300]),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(20.0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[200],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: SkeletonAnimation(
                borderRadius: BorderRadius.circular(10.0),
                shimmerColor: Colors.white,
                child: Container(
                  width: 250,
                  height: 25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[300]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10),
              child: SkeletonAnimation(
                borderRadius: BorderRadius.circular(10.0),
                shimmerColor: Colors.white,
                child: Container(
                  width: 300,
                  height: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[300]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SkeletonAnimation(
                borderRadius: BorderRadius.circular(10.0),
                shimmerColor: Colors.white,
                child: Container(
                  width: 150,
                  height: 25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[300]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SkeletonAnimation(
                borderRadius: BorderRadius.circular(10.0),
                shimmerColor: Colors.white,
                child: Container(
                  width: 250,
                  height: 25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[300]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10),
              child: SkeletonAnimation(
                borderRadius: BorderRadius.circular(10.0),
                shimmerColor: Colors.white,
                child: Container(
                  width: 300,
                  height: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[300]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SkeletonAnimation(
                borderRadius: BorderRadius.circular(10.0),
                shimmerColor: Colors.white,
                child: Container(
                  width: 150,
                  height: 25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[300]),
                ),
              ),
            ),
          ],
        ),
      )
    ],
  );
}

advertsSkeleton() {
  return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.grey.shade100,
          padding: EdgeInsets.only(bottom: 20, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SkeletonAnimation(
                          borderRadius: BorderRadius.circular(10.0),
                          shimmerColor: Colors.white,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonAnimation(
                              borderRadius: BorderRadius.circular(10.0),
                              shimmerColor: Colors.white,
                              child: Container(
                                width: 100,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Row(
                              children: [
                                SkeletonAnimation(
                                  borderRadius: BorderRadius.circular(10.0),
                                  shimmerColor: Colors.white,
                                  child: Container(
                                    width: 60,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                ),
                                SkeletonAnimation(
                                  borderRadius: BorderRadius.circular(10.0),
                                  shimmerColor: Colors.white,
                                  child: Container(
                                    width: 40,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    SkeletonAnimation(
                      borderRadius: BorderRadius.circular(10.0),
                      shimmerColor: Colors.white,
                      child: Container(
                        width: double.infinity,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    SkeletonAnimation(
                      borderRadius: BorderRadius.circular(10.0),
                      shimmerColor: Colors.white,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    SkeletonAnimation(
                      borderRadius: BorderRadius.circular(10.0),
                      shimmerColor: Colors.white,
                      child: Container(
                        width: double.infinity,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SkeletonAnimation(
                shimmerColor: Colors.white,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey.shade400,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SkeletonAnimation(
                          borderRadius: BorderRadius.circular(10.0),
                          shimmerColor: Colors.white,
                          child: Container(
                            width: 40,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        AutoSizeText(
                          " : تعليقات  ",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SkeletonAnimation(
                          borderRadius: BorderRadius.circular(10.0),
                          shimmerColor: Colors.white,
                          child: Container(
                            width: 40,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white)),
                          child: Center(
                            child: Icon(Icons.thumb_up,
                                size: 12, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SkeletonAnimation(
                    borderRadius: BorderRadius.circular(10.0),
                    shimmerColor: Colors.white,
                    child: Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  SkeletonAnimation(
                    borderRadius: BorderRadius.circular(10.0),
                    shimmerColor: Colors.white,
                    child: Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
}

commentSkeleton(context) {
  List<int> randomHeights = [];
  Random rand = Random();
  for (int i = 0; i < 6; i++) {
    randomHeights.add(rand.nextInt(50) + 10);
    print(rand.nextInt(30) + 10);
  }
  return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonAnimation(
                borderRadius: BorderRadius.circular(10.0),
                shimmerColor: Colors.white,
                child: Container(
                  width: MediaQuery.of(context).size.width - 110,
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            SkeletonAnimation(
                              borderRadius: BorderRadius.circular(10.0),
                              shimmerColor: Colors.white,
                              child: Container(
                                width: 100,
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: SkeletonAnimation(
                          borderRadius: BorderRadius.circular(10.0),
                          shimmerColor: Colors.white,
                          child: Container(
                            width: 120,
                            height: 10,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SkeletonAnimation(
                        borderRadius: BorderRadius.circular(10.0),
                        shimmerColor: Colors.white,
                        child: Container(
                          width: double.infinity,
                          height: randomHeights[index].toDouble(),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              CircleAvatar(
                  backgroundColor: Colors.white,
                  child: SkeletonAnimation(
                    borderRadius: BorderRadius.circular(10.0),
                    shimmerColor: Colors.white,
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300, shape: BoxShape.circle),
                    ),
                  )),
            ],
          ),
        );
      });
}
