# Book Club — CSEN 268 HW4

A Flutter Book Club app with GoRouter navigation, AuthenticationBloc, and a Cubit
for sorting seven sample books.

## Run and test

~~~powershell
flutter pub get
flutter run -d chrome
dart format lib test
flutter analyze
flutter test
flutter build web --release
~~~

## Routes and demo login

| Route name | Path |
| --- | --- |
| home | / |
| byAuthor | /byAuthor |
| byAuthorDetail | /byAuthor/detail |
| byTitle | /byTitle |
| byTitleDetail | /byTitle/detail |
| profile | /profile |
| login | /login |

Select **Login** to use the local demo account; no credentials are required.
Logged-out users are redirected to /login. Logged-in visits to /login redirect
to /byAuthor. Logout or browser refresh ends the in-memory session.

The shell provides author, title, and profile tabs. Selecting a book opens its
details; back returns to the matching list. Detail URLs identify the book with
a title query parameter, such as /byTitle/detail?book=Memory.

## References and attribution

- [Professor's L08.03 routing and authentication example](https://github.com/mehmetartun/CSEN268-F26/tree/L08.03)
- [Professor's L07.01 example](https://github.com/mehmetartun/CSEN268-F26/tree/L07.01)
- [Course Figma reference](https://www.figma.com/design/wcYRRRfWaIBVJa26BAqnqg/HW3---Instructions?node-id=0-1)

Book covers come from the course Figma reference and belong to their respective
owners. Descriptions are demonstration discussion text.
