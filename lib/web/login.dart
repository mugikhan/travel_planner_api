class HtmlPages {
  static String loginPage(
    Uri requestUri,
    String? responseType,
    String? clientID,
    String? state, {
    String? scope,
  }) {
    return """ 
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login</title>
        <link
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
            rel="stylesheet"
        />
        <link
            href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap"
            rel="stylesheet"
        />
        <link
            href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.0.1/mdb.min.css"
            rel="stylesheet"
        />
        <style>
            .gradient-custom {
              background: #6a11cb;
              background: -webkit-linear-gradient(to right, rgba(106, 17, 203, 1), rgba(37, 117, 252, 1));
              background: linear-gradient(to right, rgba(106, 17, 203, 1), rgba(37, 117, 252, 1))
            }

            .invalid-feedback {
              font-size: 11px;
            }
        </style>
    </head>

    <body>
        <section class="vh-100 gradient-custom">
            <div class="container py-5 h-100">
              <div class="row d-flex justify-content-center align-items-center h-100">
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                  <div class="card bg-dark text-white" style="border-radius: 1rem;">
                    <div class="card-body p-5 text-center">
          
                      <div class="mb-md-5 mt-md-4 pb-5">
          
                        <h2 class="fw-bold mb-2 text-uppercase">Login</h2>
                        <p class="text-white-50 mb-5">Please enter your email and password!</p>

                        <form class="needs-validation" novalidate>
                          <input type="hidden" name="state" value="$state">
                          <input type="hidden" name="client_id" value="$clientID">
                          <input type="hidden" name="response_type" value="$responseType">
                          <div class="form-outline form-white mb-4">
                            <input type="email" id="username" class="form-control form-control-lg" required>
                            <label class="form-label" for="username">Email</label>
                            <div class="invalid-feedback">Please enter a valid email.</div>
                          </div>
            
                          <div class="form-outline form-white mb-4">
                            <input type="password" id="password" class="form-control form-control-lg" required minlength="8"/>
                            <label class="form-label" for="password">Password</label>
                            <div class="invalid-feedback">Please enter a valid 8 character password</div>
                          </div>
            
                          <p class="small mb-5 pb-lg-2"><a class="text-white-50" href="#!">Forgot password?</a></p>
            
                          <button class="btn btn-outline-light btn-lg px-5" type="submit">Login</button>
                      </form>
                        
                        <!-- Login with socials -->
                        <!-- <div class="d-flex justify-content-center text-center mt-4 pt-1">
                          <a href="#!" class="text-white"><i class="fab fa-facebook-f fa-lg"></i></a>
                          <a href="#!" class="text-white"><i class="fab fa-twitter fa-lg mx-4 px-2"></i></a>
                          <a href="#!" class="text-white"><i class="fab fa-google fa-lg"></i></a>
                        </div> -->
          
                      </div>
          
                      <div>
                        <p class="mb-0">Don't have an account? <a href="/register" class="text-white-50 fw-bold">Sign Up</a>
                        </p>
                      </div>
          
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </section>
    </body>

    <script
      type="text/javascript"
      src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.0.1/mdb.min.js"
    ></script>

    <script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
    (() => {
      'use strict';

      const forms = document.querySelectorAll('.needs-validation');

      Array.prototype.slice.call(forms).forEach((form) => {
        form.addEventListener('submit', (event) => {
          if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
          }
          form.classList.add('was-validated');

          if(form.checkValidity()){
            event.preventDefault();
            const details = {
              'username': form.elements['username'].value,
              'password': form.elements['password'].value,
            };
            var formBody = [];
            for (var property in details) {
              var encodedKey = encodeURIComponent(property);
              var encodedValue = encodeURIComponent(details[property]);
              formBody.push(encodedKey + "=" + encodedValue);
            }
            formBody = formBody.join("&");

            fetch(`${requestUri.path}`, {
                method: 'POST',
                headers: {
                  'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formBody
            })
            .then(async (response) => {
              let url = await response.url;

              console.log(url)

              Swal.fire({
                icon: 'success',
                title: 'Success!',
                text: 'You are now logged in.',
                confirmButtonText: "Done",
                allowOutsideClick: false,
                width: "90%"
              }).then((result) => {
                if (result.isConfirmed) {
                  window.location.replace(url);
                }
              })
            })
            .catch((err) => {
              Swal.fire({
                icon: 'error',
                title: 'Error!',
                text: 'Something went wrong.',
                confirmButtonText: "Retry",
                allowOutsideClick: false,
                width: "90%"
              }).then((result) => {
                if (result.isConfirmed) {
                  Swal.close();
                }
              })
            })
          }
        }, false);
      });
    })();
    </script>

    </html>
    """;
  }
}
