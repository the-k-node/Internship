import React from 'react';
import Grid from '@material-ui/core/Grid';
import FormRenderer from '@data-driven-forms/react-form-renderer/form-renderer';
import componentTypes from '@data-driven-forms/react-form-renderer/component-types';
import validatorTypes from '@data-driven-forms/react-form-renderer/validator-types';
import FormTemplate from '@data-driven-forms/mui-component-mapper/form-template';
import TextField from '@data-driven-forms/mui-component-mapper/text-field';
import Checkbox from '@data-driven-forms/mui-component-mapper/checkbox';
import Select from '@data-driven-forms/mui-component-mapper/select';
import Slider from '@data-driven-forms/mui-component-mapper/slider';
import Container from "@material-ui/core/Container";

const componentMapper = {
  [componentTypes.TEXT_FIELD]: TextField,
  [componentTypes.CHECKBOX]: Checkbox,
  [componentTypes.SELECT]: Select,
  [componentTypes.SLIDER]: Slider,
};
const schema = {
  fields: [
    {
      name: 'username',
      label: 'User name',
      component: componentTypes.TEXT_FIELD,
      isRequired: true,
      validate: [
        {
          type: validatorTypes.REQUIRED
        }
      ]
    },
    {
      name: 'password',
      label: 'Password',
      component: componentTypes.TEXT_FIELD,
      isRequired: true,
      type: 'password',
      validate: [
        {
          type: validatorTypes.REQUIRED
        }
      ]
    },
    {
      component: componentTypes.CHECKBOX,
      name: "checkbox",
      label: "some random label to check in",
      isRequired: true,
      validate: [
        {
          type: validatorTypes.REQUIRED
        }
      ],
      initialValue: 0
    },
    {
      component: componentTypes.SELECT,
      name: "selector",
      options: [
        {
          value: "IN",
          label: "India"
        },
        {
          value: "US",
          label: "USA"
        },
        {
          value: "JP",
          label: "Japan"
        }
      ],
      label: "select country",
      placeholder: "choose one",
      helperText: "helper text to make you understand"
    },
    {
      component: componentTypes.SLIDER,
      name: "Some slider",
      label: "slide it!",
      helperText: "lets you slide",
      initialValue: 0,
      min: 0,
      max: 100,
      step: 5
    },
  ]
};
const FormTemplateCanReset = (props) => <FormTemplate {...props} canReset />;
const LoginForm = () => (
  <Container style={{ padding: 200 }}>
    <Grid spacing={3} container>
      <FormRenderer
        componentMapper={componentMapper}
        FormTemplate={FormTemplateCanReset}
        schema={schema}
        onSubmit={
          (data) => alert(JSON.stringify(data))
        }
        onCancel={() => console.log('Cancelled')}
        subscription={{ values: true }}
      />
    </Grid>
  </Container>
);
export default LoginForm;
