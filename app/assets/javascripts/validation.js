$(function($) {
  $('#signinnform').bootstrapValidator({
    message: 'This value is not valid',
    feedbackIcons: {
      valid: 'glyphicon glyphicon-ok',
      invalid: 'glyphicon glyphicon-remove',
       validating: 'glyphicon glyphicon-refresh'
    },
    fields: {
      "user[email]" : {
        validators: {
          notEmpty: {
            message: 'The email address is required and can\'t be empty'
          },
          emailAddress: {
            message: 'The input is not a valid email address'
          }
        }
      },

      "user[password]" : {
        message: 'The password field cannot be empty',
        validators: {
          notEmpty: {
            message: 'The password is required and can\'t be empty'
          }
          
        }
      }



      
    }
  });

    $('#signupform').bootstrapValidator({
    message: 'This value is not valid',
    feedbackIcons: {
      valid: 'glyphicon glyphicon-ok',
      invalid: 'glyphicon glyphicon-remove',
       validating: 'glyphicon glyphicon-refresh'
    },
    fields: {
      "user[full_name]": {
        message: 'The full_name is not valid',
        validators: {
          notEmpty: {
            message: 'The full name is required and can\'t be empty'
          },
          stringLength: {
            min: 6,
            max: 30,
            message: 'The full name must be more than 6 and less than 30 characters long'
          }
          
        }
      },

      "user[username]": {
        message: 'The username is not valid',
        validators: {
          notEmpty: {
            message: 'The username is required and can\'t be empty'
          },
          stringLength: {
            min: 6,
            max: 20,
            message: 'The username must be more than 5 and less than 20 characters long'
          },
          regexp: {
            regexp: /^[a-zA-Z0-9_\.]+$/,
            message: 'The username can only consist of alphabetical, number, dot and underscore'
          }
        }
      },

      "user[email]" : {
        validators: {
          notEmpty: {
            message: 'The email address is required and can\'t be empty'
          },
          emailAddress: {
            message: 'The input is not a valid email address'
          }
        }
      },

      "user[password]" : {
        message: 'The password field cannot be empty',
        validators: {
          notEmpty: {
            message: 'The password is required and can\'t be empty'
          },
          stringLength: {
            min: 8,
            max: 30,
            message: 'The password must be more than 6 and less than 30 characters long'
          }
          
        }
      },

      "user[password_confirmation]" : {
        message: 'The password field cannot be empty',
        validators: {
          identical: {
            field: 'user[password]',
            message: 'The password and its confirm are not the same'
          }
        }
      }
    }

  });

  $('#profile_edit_form').bootstrapValidator({
    message: 'This value is not valid',
    feedbackIcons: {
      valid: 'glyphicon glyphicon-ok',
      invalid: 'glyphicon glyphicon-remove',
       validating: 'glyphicon glyphicon-refresh'
    },
    fields: {
      "user[full_name]": {
        message: 'The full_name is not valid',
        validators: {
          notEmpty: {
            message: 'The full name is required and can\'t be empty'
          },
          stringLength: {
            min: 6,
            max: 30,
            message: 'The full name must be more than 6 and less than 30 characters long'
          }
          
        }
      },

      "user[username]": {
        message: 'The username is not valid',
        validators: {
          notEmpty: {
            message: 'The username is required and can\'t be empty'
          },
          stringLength: {
            min: 6,
            max: 30,
            message: 'The username must be more than 6 and less than 30 characters long'
          },
          regexp: {
            regexp: /^[a-zA-Z0-9_\.]+$/,
            message: 'The username can only consist of alphabetical, number, dot and underscore'
          }
        }
      },

      "user[email]" : {
        validators: {
          notEmpty: {
            message: 'The email address is required and can\'t be empty'
          },
          emailAddress: {
            message: 'The input is not a valid email address'
          }
        }
      },

      "user[current_password]" : {
        message: 'The password field cannot be empty',
        validators: {
          notEmpty: {
            message: 'The password is required and can\'t be empty'
          },
          stringLength: {
            min: 8,
            max: 30,
            message: 'The password must be more than 6 and less than 30 characters long'
          }
          
        }
      }
    }
  });

  $('#edit_linkss_form').bootstrapValidator({
      message: 'This value is not valid',
      feedbackIcons: {
        valid: 'glyphicon glyphicon-ok',
        invalid: 'glyphicon glyphicon-remove',
         validating: 'glyphicon glyphicon-refresh'
      },
      fields: {

        "user[email]" : {
          validators: {
            notEmpty: {
              message: 'The email address is required and can\'t be empty'
            },
            emailAddress: {
              message: 'The input is not a valid email address'
            }
          }
        }
      }
    });



});
