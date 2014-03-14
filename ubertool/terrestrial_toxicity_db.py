# -*- coding: utf-8 -*-
"""
Created on Tue Jan 31 11:55:40 2012

@author: jharston
"""
import os
os.environ['DJANGO_SETTINGS_MODULE']='settings'
from django import forms
from django.db import models
from google.appengine.api import users
from google.appengine.ext import db
from terrestrial_toxicity import TerrestrialToxicity
import datetime

YN = (('Yes','Yes'),('No','No'))
LC50_LD50 = (('LC50','LC50'),('LD50','LD50'))

class TTInp(forms.Form):
    user_terrestrial_toxicity_configuration = forms.ChoiceField(label="User Saved Terrestrial Toxicity Configuration",required=True)
    config_name = forms.CharField(label="Terrestrial Toxicity Configuration Name", initial="terr-config-%s"%datetime.datetime.now())
    avian_ld50 = forms.FloatField(label='Avian LD50 (mg/kg-bw)')
    avian_ld50_species = forms.CharField(label='Avian LD50 species')
    low_bird_acute_oral_ld50 = forms.FloatField(label='Avian LD50 lowest dose(mg/kg-bw)')
    bird_acute_oral_study = forms.CharField(label='Avian acute oral study MRID number')
    bird_acute_oral_study_comments = forms.CharField(label='Avian acute oral study comments')
    avian_ld50_water = forms.FloatField(label='Avian Drinking Water LD50 (mg/kg-bw)')
    avian_lc50 = forms.FloatField(label='Avian LC50 (mg/kg-bw)')
    avian_NOAEC = forms.FloatField(label='Avian NOAEC (mg/kg-diet)')
    avian_NOAEL = forms.FloatField(label='Avian NOAEL (mg/kg-bw)')
    Species_of_the_tested_bird = forms.CharField(label='Species of the tested bird')
    Species_of_the_tested_bird_avian_LD50 = forms.CharField(label='Species of the tested bird LD50')
    Species_of_the_tested_bird_avian_LC50 = forms.CharField(label='Species of the tested bird LC50')
    Species_of_the_tested_bird_avian_NOAEC = forms.CharField(label='Species of the tested bird NOAEC')
    Species_of_the_tested_bird_avian_NOAEL = forms.CharField(label='Species of the tested bird NOAEL')
    body_weight_of_the_assessed_bird = forms.FloatField(label='Body weight of assessed bird (g)')
    body_weight_of_the_assessed_bird_sm = forms.FloatField(label='Body weight of assessed small bird (g)')
    body_weight_of_the_assessed_bird_md = forms.FloatField(label='Body weight of assessed medium bird (g)')
    body_weight_of_the_assessed_bird_lg = forms.FloatField(label='Body weight of assessed large bird (g)')
    bw_quail = forms.FloatField(label='Body weight of the assessed quail (g)')
    bw_duck = forms.FloatField(label='Body weight of the assessed duck (g)')
    m_species = forms.FloatField(label='Species of the tested mammal')
    bwb_other = forms.FloatField(label='Body weight of the assessed bird (g)')
    mineau_scaling_factor = forms.FloatField(label='Chemical Mineau scaling factor')
    m_species = forms.FloatField(label='Species of the tested mammal')
    mammalian_ld50 = forms.FloatField(label='Mammalian LD50 (mg/kg-bw)')
    ld50_m = forms.FloatField(label='Mammilian Drinking Water LD50 (mg/kg-bw)')
    mammalian_lc50 = forms.FloatField(label='Mammalian LC50 (mg/kg-diet)')
    mammalian_inhalation_lc50 = forms.FloatField(label='Mammalian Inhalation LC50 (mg/L)')
    duration_of_rat_study = forms.FloatField(label='Duration of mammal inhalation study')
    mamm_acute_derm_ld50 = forms.FloatField(label='Mammalian acute Dermal LD50')
    mamm_acute_derm_study = forms.CharField(label='Mammalian acute dermal LD50 study')
    mamm_study_add_comm = forms.CharField(label='Mammalian acute dermal study additional comments')
    mammalian_chronic_endpoint = forms.CharField(label='Mammalian chronic endpoint (NOAEL or NOAEC)')
    mammalian_NOAEC = forms.FloatField(label='Mammalian NOAEC (mg/kg-diet)')
    mammalian_NOAEL = forms.FloatField(label='Mammalian NOAEL (mg/kg-bw)')
    tested_mamm_body_weight = forms.FloatField(label='Body weight of the tested mammal (g)') 
    bw_rat = forms.FloatField(label='Body Weight of tested mammal - Lab Rat(g)')
    bwm_other = forms.FloatField(label='Body Weight of tested mammal - Other (g)')
    body_weight_of_the_assessed_mammal_sm = forms.FloatField(label='Body weight of assessed small mammal (g)')
    body_weight_of_the_assessed_mammal_md = forms.FloatField(label='Body weight of assessed medium mammal (g)')
    body_weight_of_the_assessed_mammal_lg = forms.FloatField(label='Body weight of assessed large mammal (g)')
    terrestrial_phase_amphibian_ld50 = forms.FloatField(label='Terrestrial phase amphibian LD50 (mg/kg-bw)')
    terrestrial_phase_amphibian_ld50_species = forms.CharField(label='Terrestrial phase amphibian LD50 Species')
    terrestrial_phase_amphibian_ld50_bw = forms.FloatField(label='Terrestrial phase amphibian LD50 Body Weight (g)')
    terrestrial_phase_amphibian_lc50 = forms.FloatField(label='Terrestrial phase amphibian LC50 (mg/kg-diet)')
    terrestrial_phase_amphibian_lc50_species = forms.CharField(label='Terrestrial phase amphibian LC50 Species')
    terrestrial_phase_amphibian_lc50_bw = forms.FloatField(label='Terrestrial phase amphibian LC50 Body Weight (g)')
    terrestrial_phase_amphibian_NOAEC = forms.FloatField(label='Terrestrial phase amphibian NOAEC (mg/kg-diet)')
    terrestrial_phase_amphibian_NOAEC_species = forms.CharField(label='Terrestrial phase amphibian NOAEC Species')
    terrestrial_phase_amphibian_NOAEC_bw = forms.FloatField(label='Terrestrial phase amphibian NOAEC Body Weight (g)')
    terrestrial_phase_amphibian_NOAEL = forms.FloatField(label='Terrestrial phase amphibian NOAEL (mg/kg-bw)')  
    terrestrial_phase_amphibian_NOAEL_species = forms.CharField(label='Terrestrial phase amphibian NOAEL Species')
    terrestrial_phase_amphibian_NOAEL_bw = forms.FloatField(label='Terrestrial phase amphibian NOAEL Body Weight (g)')
    terrestrial_phase_reptile_ld50 = forms.FloatField(label='Terrestrial phase reptile LD50 (mg/kg-bw)')
    terrestrial_phase_reptile_ld50_species = forms.CharField(label='Terrestrial phase reptile LD50 Species')
    terrestrial_phase_reptile_ld50_bw = forms.FloatField(label='Terrestrial phase reptile LD50 Body Weight (g)')
    terrestrial_phase_reptile_lc50 = forms.FloatField(label='Terrestrial phase reptile LC50 (mg/kg-diet)')
    terrestrial_phase_reptile_lc50_species = forms.CharField(label='Terrestrial phase reptile LC50 Species')
    terrestrial_phase_reptile_lc50_bw = forms.FloatField(label='Terrestrial phase reptile LC50 Body Weight (g)')
    terrestrial_phase_reptile_NOAEC = forms.FloatField(label='Terrestrial phase reptile NOAEC (mg/kg-diet)')
    terrestrial_phase_reptile_NOAEC_species = forms.CharField(label='Terrestrial phase reptile NOAEC Species')
    terrestrial_phase_reptile_NOAEC_bw = forms.FloatField(label='Terrestrial phase reptile NOAEC Body Weight (g)')
    terrestrial_phase_reptile_NOAEL = forms.FloatField(label='Terrestrial phase reptile NOAEL (mg/kg-bw)')  
    terrestrial_phase_reptile_NOAEL_species = forms.CharField(label='Terrestrial phase reptile NOAEL Species')
    terrestrial_phase_reptile_NOAEL_bw = forms.FloatField(label='Terrestrial phase reptile NOAEL Body Weight (g)')
    EC25_for_nonlisted_seedling_emergence_monocot = forms.FloatField(label='Terrestrial plants: Seedling emergence monocot EC25 (lbs ai/acre)')
    NOAEC_for_listed_seedling_emergence_monocot = forms.FloatField(label='Terrestrial plants: Seedling emergence monocot NOAEC/EC05 (lbs ai/acre)')
    EC25_for_nonlisted_seedling_emergence_dicot = forms.FloatField(label='Terrestrial plants: Seedling emergence dicot EC25 (lbs ai/acre)')
    NOAEC_for_listed_seedling_emergence_dicot = forms.FloatField(label='Terrestrial plants: Seedling emergence monocot NOAEC/EC05 (lbs ai/acre)')
    EC25_for_nonlisted_vegetative_vigor_monocot = forms.FloatField(label='Terrestrial plants: Seedling emergence monocot EC25 (lbs ai/acre)')
    body_weight_of_the_consumed_mammal_a = forms.FloatField(label='Weight of the mammal consumed by assessed frog') 
    body_weight_of_the_consumed_herp_a = forms.FloatField(label='Weight of the herptile consumed by assessed frog') 
    NOAEC_for_listed_vegetative_vigor_monocot = forms.FloatField(label='Terrestrial plants: Seedling emergence monocot NOAEC/EC05 (lbs ai/acre)')
    NOAEC_for_listed_vegetative_vigor_dicot = forms.FloatField(label='Terrestrial plants: Seedling emergence dicot NOAEC/EC05 (lbs ai/acre)')
    EC25_for_nonlisted_vegetative_vigor_dicot = forms.FloatField(label='Terrestrial plants: Seedling emergence dicot EC25 (lbs ai/acre)')
    bw_herp_a_sm = forms.FloatField(label='Small assessed herptile listed species body weight')
    bw_herp_a_md = forms.FloatField(label='Medium assessed herptile listed species body weight')
    bw_herp_a_lg = forms.FloatField(label='Large assessed herptile listed species body weight')
    wp_herp_a_sm = forms.FloatField(label='Percent water content of small herptile species diet')
    wp_herp_a_md = forms.FloatField(label='Percent water content of medium herptile species diet')
    wp_herp_a_lg = forms.FloatField(label='Percent water content of large herptile species diet')
    taxonomic_group = forms.CharField(widget=forms.Textarea (attrs={'cols': 20, 'rows': 2}),label='What taxonomic group are you assessing?')    
    eat_mammals = forms.ChoiceField(label='Does the assessed animal eat mammals' , choices=YN, initial='Yes')
    eat_amphibians_reptiles = forms.ChoiceField(label='Does the assessed animal eat amphibians or reptiles?' , choices=YN, initial='Yes')
    desired_threshold = forms.FloatField(label='Desired threshold')
    slope_of_dose_response = forms.FloatField(label='Slope of dose-response')
    lc50_or_ld50 = forms.ChoiceField(label='LC50 or LD50?' , choices=LC50_LD50, initial='LC50')
                                                                                                                                