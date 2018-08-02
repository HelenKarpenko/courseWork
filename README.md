# Fitnes life

#### [Docs](https://docs.google.com/document/d/1bxz1ocSrlYOd6PsBJMXv9oBXpvpd-GnsiGihsjskHCo/edit?usp=sharing)

## Motivation
This project was done as a part of the course work: **application of programming templates in software development.**
## The main idea

### Features
1. The user can register by email and password.
1. The client is authorized by the server using a key JWT-strategy (access/refresh token). 
2. The user can create wallet with specific name and currency.
3. The user can add transaction to wallet with different currency, then it was specified in wallet.
4. The user can delete wallet and transactions.
5. The user can view chart with all transactions.
6. The server makes requests National Bank of Ukraine and gets actual currencies rate every day. 
7. The server and the client communicate using only GraphQL.

### Prerequisites

You need have installed Node.js environment and npm manager. [Here is link to tutorial](https://www.npmjs.com/get-npm) 


## Getting Started
**Client side**
1. Go to directory with client sources
   ```sh
   cd src/client
   ```
2. Make sure you have npm installed. Then install dependencies with command
    ```sh
    npm i
    ```    
3. **Dev mode** allows you run client app on local machine without server (it's bundled)
    ```sh
    npm start
    ```
4.  **Production build**  next command build bundle for production use, minimize code and compress it
    ```sh
    npm run build
    ```
## Built With
* [Swift]()
* DB

## Versioning
We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/ZulusK/Budgetarium/tags). 

## Authors

* **Karpenko Olena** - *iOS developer* - [HelenKarpenko](https://github.com/HelenKarpenko)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
