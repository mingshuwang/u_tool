# -*- coding: utf-8 -*-
"""
Created on Tue Jan 17 14:50:59 2012

@author: T.Hong
"""
import os
os.environ['DJANGO_SETTINGS_MODULE']='settings'
from django import forms
from django.db import models
from django.utils.safestring import mark_safe

class exponentialInp(forms.Form):
    N_o = forms.FloatField(required=True,label=mark_safe('Initial amount of individuals (N<sub>0</sub>)'),initial=100)
    rho = forms.FloatField(required=True,label=mark_safe('Initial growth rate in percent (&#961;)'),initial=4)
    T = forms.FloatField(required=True,label='Number of time intervals (T)',initial=200)
